module KnowledgeBase
  class ArticlesDatatable
    include SimpleDatatable

    sort_columns %w[knowledge_base_articles.id knowledge_base_articles.title null knowledge_base_articles.updated_at]

    def render(article)
      {
          id: article.link_id,
          title: article.link_title,
          tags_list: article.render_tag_list,
          updated_at: article.render_updated_at,
      }
    end
  end
end