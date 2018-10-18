module Admin
  module Blog
    class PostsController < Admin::ApplicationController
      power :admin_blog_posts, as: :posts_scope

      decorates_assigned :post, :posts

      def index
        @posts = posts_scope.includes(:tags, :user)

        respond_to do |format|
          format.html
          format.json { render json: PostsDatatable.new(@posts, view_context) }
        end
      end

      def show
        @post = posts_scope.find(params[:id])
      end

      def new
        @post = posts_scope.new
      end

      def create
        @post = posts_scope.new(post_params.merge(user: current_user))

        if @post.save
          flash[:notice] = 'Your post has been created.'
          redirect_to [:admin, :blog, @post]
        else
          render :new
        end
      end

      def edit
        @post = posts_scope.find(params[:id])
      end

      def update
        @post = posts_scope.find(params[:id])

        if @post.update_attributes(post_params)
          flash[:notice] = 'The post has been updated.'
          redirect_to [:admin, :blog, @post]
        else
          render :edit
        end
      end

      def destroy
        @post = posts_scope.find(params[:id])

        if @post.destroy
          flash[:notice] = 'The post has been deleted.'
          redirect_to [:admin, :blog, :posts]
        end
      end

      def post_params
        params.require(:post).permit(:title, :body, :summary, :status, :tag_list)
      end
    end
  end
end