require 'spec_helper'

feature 'blog/posts' do
  feature "user views blog post" do
    given!(:post) { create :published_blog_post }

    scenario do
      visit post.decorate.frontend_path

      expect(page).to have_content(post.title)
      expect(page).to have_content(post.body)
    end
  end

  feature 'user views blog posts' do
    given!(:posts) { 3.times.map { create :published_blog_post, tag_list: 'windows' } }
    given!(:draft_post) { create :draft_blog_post, tag_list: 'test' }
    given!(:tagged_post) { create :published_blog_post, tag_list: 'linux' }

    scenario do
      visit blog_posts_path

      expect(page).to_not have_content(draft_post.title)

      posts.each do |post|
        expect(page).to have_content(post.title)
      end
    end

    context 'with a specific search' do
      scenario do
        visit blog_posts_path(search: 'linux')

        expect(page).to have_content(tagged_post.title)

        posts.each do |post|
          expect(page).to_not have_content(post.body)
        end
      end
    end
  end
end