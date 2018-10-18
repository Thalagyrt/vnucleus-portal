atom_feed :language => 'en-US' do |feed|
  feed.title "vNucleus Blog"
  feed.updated Time.now

  posts.each do |post|
    feed.entry(post, url: post.frontend_url) do |entry|
      entry.url post.frontend_url
      entry.title post.title
      entry.content post.render_synopsis, :type => 'html'

      entry.updated(post.published_at.strftime("%Y-%m-%dT%H:%M:%SZ"))
      entry.author post.user.full_name
    end
  end
end