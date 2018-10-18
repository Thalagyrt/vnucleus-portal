class AddPublishedAtToBlogPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :published_at, :datetime
    add_index :blog_posts, :published_at

    execute 'UPDATE blog_posts SET published_at=created_at'
  end
end
