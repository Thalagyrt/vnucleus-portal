module Monitoring
  class CheckViewDecorator < Draper::Decorator
    delegate_all

    decorates_association :check
  end
end