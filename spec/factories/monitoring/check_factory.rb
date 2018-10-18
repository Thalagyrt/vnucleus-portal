FactoryGirl.define do
  factory :check, class: Monitoring::Check do
    server { create :solus_server }
    next_run_at { Time.zone.now }
    check_type :icmp
    notify_staff true
    notify_account true
    status_code :ok
    failure_count 0
    enabled true

    factory :critical_check do
      status_code :critical
      failure_count 4

      factory :disabled_critical_check do
        enabled false
      end
    end

    factory :disabled_check do
      enabled false
    end

    factory :icmp_check

    factory :http_check do
      check_type :http
      check_data "http://localhost/"
    end

    factory :ssl_validity_check do
      check_type :ssl_validity
      check_data "https://localhost/"
    end

    factory :tcp_check do
      check_type :tcp
      check_data "22"
    end

    factory :nrpe_check do
      check_type :nrpe
      check_data "check_load"
    end
  end
end