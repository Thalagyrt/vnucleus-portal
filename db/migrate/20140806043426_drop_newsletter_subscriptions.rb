class DropNewsletterSubscriptions < ActiveRecord::Migration
  def change
    drop_table :users_newsletter_subscriptions
  end
end
