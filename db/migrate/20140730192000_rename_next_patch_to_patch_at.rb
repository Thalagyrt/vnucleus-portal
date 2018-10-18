class RenameNextPatchToPatchAt < ActiveRecord::Migration
  def change
    rename_column :solus_servers, :next_patch, :patch_at
  end
end
