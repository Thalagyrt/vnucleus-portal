require 'spec_helper'

feature 'knowledge base/articles' do
  given!(:user) { create :staff_user }

  background { sign_in user }

  feature 'admin creates knowledge base article' do
    scenario do
      visit new_admin_knowledge_base_article_path

      fill_in 'article_title', with: 'Hipsters'
      fill_in 'article_body', with: 'Derpy Bogsworth is a hipster!'
      fill_in 'article_summary', with: 'Derpy Bogsworth is a hipster!'
      fill_in 'article_tag_list', with: 'loonix'
      click_button 'article_submit'

      expect(page).to have_content('Hipsters')
      expect(page).to have_content('Derpy Bogsworth is a hipster!')
      expect(page).to have_content('Draft')
      expect(page).to have_content('loonix')
    end
  end

  feature "admin deletes knowledge base article" do
    given!(:article) { create :knowledge_base_article }

    scenario do
      visit admin_knowledge_base_article_path(article)

      click_link "Delete Article"

      expect(page).to_not have_content(article.title)
    end
  end

  feature "admin updates knowledge base article" do
    given!(:article) { create :draft_knowledge_base_article }

    scenario do
      visit edit_admin_knowledge_base_article_path(article)

      fill_in 'article_title', with: 'Hipsters'
      fill_in 'article_body', with: 'Derpy Bogsworth is a hipster!'
      fill_in 'article_tag_list', with: 'loonix'
      select 'Published', from: 'article_status'
      click_button 'article_submit'

      expect(page).to have_content('Hipsters')
      expect(page).to have_content('Derpy Bogsworth is a hipster!')
      expect(page).to have_content('Published')
      expect(page).to have_content('loonix')
    end
  end

  feature "admin views knowledge base article" do
    given!(:article) { create :draft_knowledge_base_article }

    scenario do
      visit admin_knowledge_base_article_path(article)

      expect(page).to have_content(article.title)
      expect(page).to have_content(article.body)
    end
  end

  feature "admin views knowledge base articles", js: true do
    given!(:articles) { 3.times.map { create :knowledge_base_article, tag_list: 'windows' } }

    scenario do
      visit admin_knowledge_base_articles_path

      articles.each do |article|
        expect(page).to have_content(article.title)
      end
    end
  end
end