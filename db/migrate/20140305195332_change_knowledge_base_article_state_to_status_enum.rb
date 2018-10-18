class ChangeKnowledgeBaseArticleStateToStatusEnum < ActiveRecord::Migration
  def up
    add_column :knowledge_base_articles, :status, :integer
    add_index :knowledge_base_articles, :status
    execute "UPDATE knowledge_base_articles SET status=1 WHERE state='draft'"
    execute "UPDATE knowledge_base_articles SET status=2 WHERE state='published'"
    remove_index :knowledge_base_articles, :state
    remove_column :knowledge_base_articles, :state
  end

  def down
    add_column :knowledge_base_articles, :state, :string
    add_index :knowledge_base_articles, :state
    execute "UPDATE knowledge_base_articles SET state='draft' WHERE status=1"
    execute "UPDATE knowledge_base_articles SET state='published' WHERE status=1"
    remove_index :knowledge_base_articles, :status
    remove_column :knowledge_base_articles, :status
  end
end
