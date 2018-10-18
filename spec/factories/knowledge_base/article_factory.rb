FactoryGirl.define do
  factory :knowledge_base_article, class: KnowledgeBase::Article do
    sequence(:title) { |n| "KB##{n}" }
    sequence(:body) { |n| "This is KB article ##{n}" }
    sequence(:summary) { |n| "This is KB article ##{n}" }

    factory :published_knowledge_base_article do
      status { :published }
    end

    factory :draft_knowledge_base_article do
      status { :draft }
    end
  end
end