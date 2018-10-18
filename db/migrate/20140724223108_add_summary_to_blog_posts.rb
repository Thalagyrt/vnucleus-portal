class AddSummaryToBlogPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :summary, :text
  end
end
