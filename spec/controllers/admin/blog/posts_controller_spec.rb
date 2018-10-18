require 'spec_helper'

describe Admin::Blog::PostsController do
  it_behaves_like "a protected user controller"
  it_behaves_like "a protected admin controller"

  context "with an admin user" do
    let(:user) { create :staff_user }
    let(:account) { create :account }
    before { sign_in user }

    describe "#index" do
      let!(:posts) { 3.times.map { create :published_blog_post } }
      let!(:draft_post) { create :draft_blog_post }

      it "assigns @posts" do
        get :index

        expect(assigns(:posts)).to be_present
      end

      it "includes draft posts" do
        get :index

        expect(assigns(:posts)).to include(draft_post)
      end
    end

    describe "#show" do
      context "with a published post" do
        let!(:post) { create :published_blog_post }

        it "assigns @post" do
          get :show, id: post.id

          expect(assigns(:post)).to eq(post)
        end
      end

      context "with a draft post" do
        let!(:post) { create :blog_post }

        it "assigns @post" do
          get :show, id: post.id

          expect(assigns(:post)).to eq(post)
        end
      end
    end

    describe "#new" do
      it "assigns @post" do
        get :new

        expect(assigns(:post)).to be_present
      end
    end

    describe "#create" do
      context "with valid data" do
        it "redirects away from the form" do
          post :create, post: { title: 'Derp', body: 'herpin', summary: 'derpin', tag_list: 'noobs' }

          expect(response).to be_redirect
        end
      end

      context "with invalid data" do
        it "assigns @post" do
          post :create, post: { title: '', body: 'herpin', summary: 'derpin', tag_list: 'noobs' }

          expect(assigns(:post)).to be_present
        end

        it "renders the new template" do
          post :create, post: { title: '', body: 'herpin', summary: 'derpin', tag_list: 'noobs' }

          expect(response).to render_template(:new)
        end
      end
    end

    describe "#edit" do
      let(:post) { create :blog_post }

      it "assigns @post" do
        get :edit, id: post.id

        expect(assigns(:post)).to be_present
      end
    end

    describe "#update" do
      let(:post) { create :blog_post }

      context "with valid data" do
        it "redirects away from the form" do
          put :update, id: post.id, post: { title: 'Derp', body: 'herpin', tag_list: 'noobs' }

          expect(response).to be_redirect
        end
      end

      context "with invalid data" do
        it "assigns @post" do
          put :update, id: post.id, post: { title: '', body: 'herpin', tag_list: 'noobs' }

          expect(assigns(:post)).to be_present
        end

        it "renders the new template" do
          put :update, id: post.id, post: { title: '', body: 'herpin', tag_list: 'noobs' }

          expect(response).to render_template(:edit)
        end
      end
    end

    describe "#destroy" do
      let(:post) { create :blog_post }

      it "redirects to the post index" do
        delete :destroy, id: post.id

        expect(response).to be_redirect
      end
    end
  end
end