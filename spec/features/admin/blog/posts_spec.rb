require 'spec_helper'

feature 'blog/posts' do
  given!(:user) { create :staff_user }

  background { sign_in user }

  feature 'admin creates blog post' do
    scenario do
      visit new_admin_blog_post_path

      fill_in 'post_title', with: 'Hipsters'
      fill_in 'post_body', with: 'Derpy Bogsworth is a hipster!'
      fill_in 'post_summary', with: 'Derpy Bogsworth is a hipster!'
      fill_in 'post_tag_list', with: 'loonix'
      click_button 'post_submit'

      expect(page).to have_content('Hipsters')
      expect(page).to have_content('Derpy Bogsworth is a hipster!')
      expect(page).to have_content('Draft')
      expect(page).to have_content('loonix')
    end
  end

  feature "admin deletes blog post" do
    given!(:post) { create :blog_post }

    scenario do
      visit admin_blog_post_path(post)

      click_link "Delete Post"

      expect(page).to_not have_content(post.title)
    end
  end

  feature "admin updates blog post" do
    given!(:post) { create :draft_blog_post }

    scenario do
      visit edit_admin_blog_post_path(post)

      fill_in 'post_title', with: 'Hipsters'
      fill_in 'post_body', with: 'Derpy Bogsworth is a hipster!'
      fill_in 'post_tag_list', with: 'loonix'
      select 'Published', from: 'post_status'
      click_button 'post_submit'

      expect(page).to have_content('Hipsters')
      expect(page).to have_content('Derpy Bogsworth is a hipster!')
      expect(page).to have_content('Published')
      expect(page).to have_content('loonix')
    end
  end

  feature "admin views blog post" do
    given!(:post) { create :draft_blog_post }

    scenario do
      visit admin_blog_post_path(post)

      expect(page).to have_content(post.title)
      expect(page).to have_content(post.body)
    end
  end

  feature "admin views blog posts", js: true do
    given!(:posts) { 3.times.map { create :blog_post, tag_list: 'windows' } }

    scenario do
      visit admin_blog_posts_path

      posts.each do |post|
        expect(page).to have_content(post.title)
      end
    end
  end
end