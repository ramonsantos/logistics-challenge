# Como executar

### Dependências

* Ruby 3.3.5
* Docker

### Instalar serviços

```
docker compose up -d

```

### Buidar projeto

```
bundle install
```

### Preparar banco de dados

```
bundle exec rake db:create db:migrate
```

### Executar o projeto

```
foreman start
```

### Executar testes

```
bundle exec rspec
```

# Como usar

A documentação dos endpoints está neste endereço http://localhost:3001. Abaixo temos exemplo das request:
* Requisição de importação:
```
curl --location 'http://localhost:3000/order_products/import' \
--header 'accept: application/json' \
--form 'file=@"PATH_DO_ARQUIVO"'
```
* Requisição de listagem de pedidos:
```
curl --location 'http://localhost:3000/orders?per_page=100&page=0'
```

# Descrição

O desafio foi com Ruby, Ruby on Rails, PostgreSQL, Redis, Docker, Sidekiq e RSpec.

### Importação de dados

O processo de importação começa pelo endpoint `POST /order_products/import`, responsável por receber o arquivo, escrever seu conteúdo no Redis e enfileirar o job `EnqueueOrderProductsToImportJob`, para processamento assíncrono.

O job `EnqueueOrderProductsToImportJob` é responsável por ler o conteúdo do arquivo de importação no Redis, enfileirar cada linha no job `ImportOrderProductJob` e apagar o conteúdo do arquivo no Redis. Como o tamanho do arquivo de dados pode ser grande, eu optei pelo enfileiramento através do método `perform_bulk` do Sidekiq, para reduzir a quantidade de chamadas ao Redis. (Ref.: https://github.com/sidekiq/sidekiq/wiki/Bulk-Queueing)

A importação de cada linha é processada no job `ImportOrderProductJob`. Várias linhas são processadas simutaneamente, pois configurei o Sidekiq para executar 4 processos e 50 threads cada. A lógica de importação está implementada no service `ImportOrderProductService`.

É neste service que os usuários, pedidos e itens de pedidos são criados. Para evitar duplicações de usuário e pedidos, num primeiro momento é feito uma busca no banco. Então, se um usuário já existe no banco, ele é usado para a criação do pedido. Caso contrário, ele é criado. No entanto, pode acontecer de o usuário não existir no banco de dados no momento da busca, mas durante o processo de criação, outro processo criar este mesmo usuário (race condition). Caso isso aconteça, o método `create!` lançará uma exceção, dado que adicionei uma restrição de unicidade na tabela `users` (o mesmo tratamento foi feito para pedidos). O lançamento da exceção fará um rollback na transação e o job cairá no processo de retry do Sidekiq.

Outra parte da importação que poderia dar problema devido ao problema de race condition era no cálculo do valor total de pedidos. Minha estratégia para lidar com isso foi separar a criação de pedidos e itens de pedidos da atualização do valor total. Então quando o job `ImportOrderProductService` termina de criar os dados no banco, o job `UpdateTotalOfOrderJob` é enfileirado. A implementação deste job, que é o último do "pipeline" de importação, é simples e objetiva: buscar o pedido, travar o recurso, fazer a soma do valor total, atualizar o recurso e liberar o recurso. Isso garante que se vários jobs de forem executados simultaneamente para o mesmo pedido, o primeiro update faz com que o segundo update fique esperando a primeira operação terminar.

Para tratar os dados duplicados (mesmo id para usuários e pedidos) entre os arquivos de importação, eu adicionei índices de unicidade para `user_id` e `name` na tabela `users` e `order_id` e `date` na tabela `orders`. Em uma situação real, a estratégia poderia ser diferente para ficar mais adequada ao cenário. Por exemplo, se cada arquivo pudesse vir de fontes diferentes, talvez ter uma coluna com a identificação de fonte fosse melhor.

### Listagem de pedidos

Ao analisar a parte de "Saída de dados", inicialmente eu imaginei que se tratava de listagem de usuários, pois no payload os dados de usuários estavam na "raiz" de cada objeto da lista. Mas como o desafio pedia para considerar a consulta geral de pedidos e os filtros de dados de pedidos, segui dessa forma.

O endpoint dessa listagem é o `GET /orders`. Nele é feita a busca, considerando os filtros, e a serialização dos dados. Além dos filtros pedidos, eu adicionei paginação.
