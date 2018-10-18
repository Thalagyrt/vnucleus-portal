FactoryGirl.define do
  factory :solus_template, class: Solus::Template do
    sequence(:name) { |n| "Template ##{n}" }
    virtualization_type   "xen"
    plan_part             "PV"
    template              "a_template"
    status                :active
    root_username         "root"
    autocomplete_provision true
  end
end