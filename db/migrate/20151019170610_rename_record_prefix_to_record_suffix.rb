class RenameRecordPrefixToRecordSuffix < ActiveRecord::Migration
  def change
    rename_column :solus_reverse_dns_mappings, :record_prefix, :record_suffix
  end
end
