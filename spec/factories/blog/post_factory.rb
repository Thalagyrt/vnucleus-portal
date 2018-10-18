FactoryGirl.define do
  factory :blog_post, class: Blog::Post do
    sequence(:title) { |n| "Post #{n}" }
    sequence(:body) { |n| "This is blog post ##{n}" }
    sequence(:summary) { |n| "This is blog post ##{n}" }
    user

    factory :published_blog_post do
      status { :published }
    end

    factory :draft_blog_post do
      status { :draft }
    end
  end
end