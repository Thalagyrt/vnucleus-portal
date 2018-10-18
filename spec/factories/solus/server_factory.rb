FactoryGirl.define do
  factory :solus_server, class: Solus::Server do
    sequence(:vserver_id) { |n| n }
    sequence(:hostname) { |n| "server#{n}.test.betaforce.com" }
    account { create :account }
    plan { create :solus_plan }
    template { create :solus_template }
    cluster { create :solus_cluster }
    provision_started_at { 10.seconds.ago }
    provision_completed_at { 5.seconds.ago }
    plan_amount 995
    next_due { Time.zone.today.next_month.at_beginning_of_month }

    after(:create) do |instance|
      instance.transfer = instance.plan.transfer
      instance.node ||= if instance.cluster.nodes.count > 0
                        instance.cluster.nodes.first
                      else
                        create :solus_node, cluster: instance.cluster
                      end
      instance.save
    end
  end
end