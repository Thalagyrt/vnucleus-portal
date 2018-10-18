class HostnameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless Solus::Hostname.valid_hostname?(value)
      record.errors[attribute] << (options[:message] || "is not a valid hostname")
    end
  end
end