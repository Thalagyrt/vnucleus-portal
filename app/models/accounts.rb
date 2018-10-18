module Accounts
  def self.table_name_prefix
    'accounts_'
  end

  def self.use_relative_model_naming?
    true
  end
end