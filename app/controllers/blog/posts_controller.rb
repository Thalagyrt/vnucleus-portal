module Blog
  class PostsController < ApplicationController
    power :blog_posts, as: :posts_scope

    decorates_assigned :post, :posts, :recent_posts, :author

    before_action :assign_recent_posts

    def index
      @posts = posts_scope.sorted.includes(:tags, :user)

      if params[:day].present?
        date = Time.zone.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
        @posts = @posts.where('published_at >= ?', date.at_beginning_of_day).where('published_at <= ?', date.at_end_of_day)
      elsif params[:month].present?
        date = Time.zone.parse("#{params[:year]}-#{params[:month]}-01")
        @posts = @posts.where('published_at >= ?', date.at_beginning_of_month).where('published_at <= ?', date.at_end_of_month)
      elsif params[:year].present?
        date = Time.zone.parse("#{params[:year]}-01-01}")
        @posts = @posts.where('published_at >= ?', date.at_beginning_of_year).where('published_at <= ?', date.at_end_of_year)
      end

      if params[:author].present?
        @author = Users::User.where(is_staff: true).find_by_email("#{params[:author].downcase}@vnucleus.com")
        @posts = @posts.where(user: @author)
      end

      @posts = @posts.search(params[:search]) if params[:search].present?
      respond_to do |format|
        format.html { @posts = @posts.page(params[:page]).per(5) }
        format.atom
      end

    end

    def show
      date = Time.zone.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
      @post = posts_scope.where('published_at >= ?', date.at_beginning_of_day).where('published_at <= ?', date.at_end_of_day).find(params[:id])

      redirect_to @post.decorate.frontend_path unless params[:id] == @post.to_param
    end

    private
    def assign_recent_posts
      @recent_posts = posts_scope.limit(5)
    end
  end
end