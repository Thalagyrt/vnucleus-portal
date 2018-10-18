require 'spec_helper'

describe Blog::PostsController do
  describe "#index" do
    let!(:posts) { 3.times.map { create :published_blog_post } }
    let!(:draft_post) { create :draft_blog_post }

    it "assigns @posts" do
      get :index

      expect(assigns(:posts)).to be_present
    end

    it "doesn't include unpublished posts in @posts" do
      get :index

      expect(assigns(:posts)).to_not include(draft_post)
    end
  end

  describe "#show" do
    context "with a published post" do
      let!(:post) { create :published_blog_post }

      it "assigns @post" do
        get :show, year: post.published_at.year, month: post.published_at.month, day: post.published_at.day, id: post.id

        expect(assigns(:post)).to eq(post)
      end
    end

    context "with a draft post" do
      let!(:post) { create :draft_blog_post, published_at: Time.zone.now }

      it "renders 404" do
        get :show, year: post.published_at.year, month: post.published_at.month, day: post.published_at.day, id: post.id

        expect(response.response_code).to eq(404)
      end
    end
  end
end