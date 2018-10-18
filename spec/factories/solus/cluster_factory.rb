FactoryGirl.define do
  factory :solus_cluster, class: Solus::Cluster do
    sequence(:name) { |n| "Cluster ##{n}" }
    hostname              'solustest.betaforce.com'
    ip_address            '10.0.0.1'
    api_id                'id'
    api_secret            'secret'
    facility              'SunGard'
    transit_providers     'Level3 and Cogent'
  end
end