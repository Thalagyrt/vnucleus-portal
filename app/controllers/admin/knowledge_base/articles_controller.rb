module Admin
  module KnowledgeBase
    class ArticlesController < Admin::ApplicationController
      power :admin_knowledge_base_articles, as: :articles_scope

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

        redirect_to [:admin, :knowledge_base, @article] unless params[:id] == @article.to_param
      end

      def new
        @article = articles_scope.new
      end

      def create
        @article = articles_scope.new(article_params)

        if @article.save
          flash[:notice] = 'Your article has been created.'
          redirect_to [:admin, :knowledge_base, @article]
        else
          render :new
        end
      end

      def edit
        @article = articles_scope.find(params[:id])
      end

      def update
        @article = articles_scope.find(params[:id])

        if @article.update_attributes(article_params)
          flash[:notice] = 'The article has been updated.'
          redirect_to [:admin, :knowledge_base, @article]
        else
          render :edit
        end
      end

      def destroy
        @article = articles_scope.find(params[:id])

        if @article.destroy
          flash[:notice] = 'The article has been deleted.'
          redirect_to [:admin, :knowledge_base, :articles]
        end
      end

      private
      def article_params
        params.require(:article).permit(:title, :body, :summary, :status, :tag_list)
      end
    end
  end
end