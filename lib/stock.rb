class Stock
  require './lib/finder.rb'
  include Finder

  attr_reader :products

  def initialize
    @products = set_products
  end

  def add_new_product(name, price, number)
    products.push({name: name, price: price, stock: number})
  end

  def remove(name, number)
    find_product_by_name(name)[:stock] -= number
  end

  def restock(name, number)
    find_product_by_name(name)[:stock] += number
  end

  private
  def set_products
    [{name: 'コーラ', price: 120, stock: 5}]
  end
end
