class AddSummaryToKnowledgeBaseArticles < ActiveRecord::Migration
  def change
    add_column :knowledge_base_articles, :summary, :text
  end
end
