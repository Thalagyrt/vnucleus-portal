class RenameUsersTotpTokenToOtpToken < ActiveRecord::Migration
  def change
    rename_column :users_users, :totp_token, :otp_secret
  end
end
