module Users
  def self.table_name_prefix
    'users_'
  end

  def self.use_relative_model_naming?
    true
  end
end