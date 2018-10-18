#Ahoy.subscribers << Ahoy::Subscribers::ActiveRecord.new

module Ahoy
  self.visit_duration = 30.minutes

  def self.table_name_prefix
    'ahoy_'
  end

  def self.use_relative_model_naming?
    true
  end

  class Store < Ahoy::Stores::ActiveRecordTokenStore
    def visit_model
      ::Ahoy::Visit
    end

    def event_model
      ::Ahoy::Event
    end
  end
end