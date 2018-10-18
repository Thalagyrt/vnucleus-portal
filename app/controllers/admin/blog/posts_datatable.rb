module Admin
  module Blog
    class PostsDatatable
      include SimpleDatatable

      sort_columns %w[blog_posts.title null blog_posts.created_at blog_posts.updated_at blog_posts.published_at null blog_posts.status]

      def render(post)
        {
            title: post.link_title(:admin),
            tags_list: post.render_tag_list(:admin),
            created_at: post.render_created_at,
            updated_at: post.render_updated_at,
            published_at: post.render_published_at,
            user: post.render_user,
            status: post.render_status,
        }
      end
    end
  end
end