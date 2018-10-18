module Tickets
  def self.table_name_prefix
    'tickets_'
  end

  def self.use_relative_model_naming?
    true
  end
end