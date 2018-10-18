FactoryGirl.define do
  factory :solus_node, class: Solus::Node do
    sequence(:name) { |n| "Node ##{n}" }
    ram_limit 128.gigabytes
    allocated_ram 64.gigabytes
    disk_limit 8.terabytes
    available_disk 4.terabytes
    available_ipv4 50
    available_ipv6 2000
    node_group 'HDD'
  end
end