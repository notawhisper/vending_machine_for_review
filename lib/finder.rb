module Finder
  def find_product_by_name(name)
    products.find {|i| i[:name] == name}
  end
end
