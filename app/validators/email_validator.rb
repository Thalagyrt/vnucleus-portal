class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^.@]+)(\.[^.@]+)*@([^.@]+\.)+([^.@]+)\z/
      return invalidate(record, attribute)
    end

    begin
      Mail::Address.new(value)
    rescue Mail::Field::FieldError
      return invalidate(record, attribute)
    end
  end

  private
  def invalidate(record, attribute)
    record.errors[attribute] << (options[:message] || :invalid)
  end
end