# frozen_string_literal: true

class ExtractsAttributesFromLineService < ApplicationService
  def initialize(line)
    @line = line
  end

  def call
    {
      user: user_attributes,
      order: order_attributes,
      order_product: order_product_attributes
    }
  end

  private

  attr_reader :line

  def user_attributes
    {
      user_id: extracted_attributes[:user_id].to_i,
      name: extracted_attributes[:name].strip
    }
  end

  def order_attributes
    {
      order_id: extracted_attributes[:order_id].to_i,
      user_id: extracted_attributes[:user_id].to_i,
      date: Date.parse(extracted_attributes[:date])
    }
  end

  def order_product_attributes
    {
      order_id: extracted_attributes[:order_id].to_i,
      product_id: extracted_attributes[:product_id].to_i,
      value: extracted_attributes[:value].to_f
    }
  end

  def extracted_attributes
    @extracted_attributes ||= line.match(line_regex)
  end

  def line_regex
    %r{
      ^
      (?<user_id>\d{10})
      (?<name>.{45})
      (?<order_id>.{10})
      (?<product_id>.{10})
      (?<value>.{12})
      (?<date>.{8})
      $
    }x
  end
end
