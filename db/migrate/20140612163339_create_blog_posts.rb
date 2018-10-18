class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.string :title
      t.text :body
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :status
    end

    add_index :blog_posts, :status
    add_index :blog_posts, :created_at
    add_index :blog_posts, :updated_at
  end
end
