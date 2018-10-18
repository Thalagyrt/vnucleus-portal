class CreateKnowledgeBaseArticles < ActiveRecord::Migration
  def change
    create_table :knowledge_base_articles do |t|
      t.string :title
      t.text :body
      t.string :state
      t.timestamps
    end

    add_index :knowledge_base_articles, :state
  end
end
