module Concerns
  module LongIdModelConcern
    extend ActiveSupport::Concern

    included do
      before_create :assign_long_id
    end

    module ClassMethods
      def find_by_param(long_id)
        find_by_long_id!(long_id)
      end
    end

    def to_param
      long_id
    end

    private
    def assign_long_id
      loop do
        self.long_id = StringGenerator.long_id
        break unless self.class.exists?(long_id: long_id)
      end
    end
  end
end