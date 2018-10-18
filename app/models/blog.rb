module Blog
  def self.table_name_prefix
    'blog_'
  end

  def self.use_relative_model_naming?
    true
  end
end