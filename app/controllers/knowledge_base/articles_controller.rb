module KnowledgeBase
  class ArticlesController < ApplicationController
    power :knowledge_base_articles, as: :articles_scope

    decorates_assigned :article, :articles

    def index
      @articles = articles_scope.includes(:tags)

      respond_to do |format|
        format.html
        format.json { render json: ArticlesDatatable.new(@articles, view_context) }
      end
    end

    def show
      @article = articles_scope.find(params[:id])

      redirect_to [:knowledge_base, @article] unless params[:id] == @article.to_param
    end
  end
end