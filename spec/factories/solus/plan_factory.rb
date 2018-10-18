FactoryGirl.define do
  factory :solus_plan, class: Solus::Plan do
    sequence(:name) { |n| "Plan ##{n}" }
    ram             512.megabytes
    disk            25.gigabytes
    disk_type       "HDD"
    node_group      "HDD"
    vcpus           2
    ip_addresses    1
    ipv6_addresses  16
    transfer        1.terabyte
    plan_part       "512"
    network_out     1000
    amount          995
    status          :active
  end
end