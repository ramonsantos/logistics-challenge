# frozen_string_literal: true

require 'spec_helper'

require_relative 'support/coverage'

ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort(e.to_s.strip)
end
RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # Shoulda Matchers
  Shoulda::Matchers.configure do |sm_config|
    sm_config.integrate do |with|
      with.test_framework(:rspec)
      with.library(:rails)
    end
  end

  # FactoryBot
  config.include FactoryBot::Syntax::Methods

  # Fixtures
  config.file_fixture_path = 'spec/fixtures'
end
