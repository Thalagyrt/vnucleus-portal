module Admin
  module KnowledgeBase
    class ArticlesDatatable
      include SimpleDatatable

      sort_columns %w[knowledge_base_articles.id knowledge_base_articles.title null knowledge_base_articles.created_at knowledge_base_articles.updated_at knowledge_base_articles.status]

      def render(article)
        {
            id: article.link_id(:admin),
            title: article.link_title(:admin),
            tags_list: article.render_tag_list(:admin),
            created_at: article.render_created_at,
            updated_at: article.render_updated_at,
            status: article.render_status,
        }
      end
    end
  end
end