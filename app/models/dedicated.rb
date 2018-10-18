module Dedicated
  def self.table_name_prefix
    'dedicated_'
  end

  def self.use_relative_model_naming?
    true
  end
end