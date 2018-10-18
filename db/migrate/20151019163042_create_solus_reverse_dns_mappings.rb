class CreateSolusReverseDnsMappings < ActiveRecord::Migration
  def change
    create_table :solus_reverse_dns_mappings do |t|
      t.string :cidr_prefix
      t.string :record_prefix
      t.string :zone_id
    end
  end
end
