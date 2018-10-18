module Orders
  def self.table_name_prefix
    'orders_'
  end

  def self.use_relative_model_naming?
    true
  end
end