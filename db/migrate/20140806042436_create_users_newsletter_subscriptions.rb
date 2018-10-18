class CreateUsersNewsletterSubscriptions < ActiveRecord::Migration
  def change
    create_table :users_newsletter_subscriptions do |t|
      t.string :email
      t.boolean :subscribed, default: true
    end

    add_index :users_newsletter_subscriptions, :subscribed
  end
end
