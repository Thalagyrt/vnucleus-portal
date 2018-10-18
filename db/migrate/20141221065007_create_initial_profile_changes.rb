class CreateInitialProfileChanges < ActiveRecord::Migration
  def change
    Users::User.find_each do |user|
      user.profile_changes.create(
          email: user.email, first_name: user.first_name, last_name: user.last_name,
          phone: user.phone, security_question: user.security_question, security_answer: user.security_answer,
          created_at: user.updated_at
      )
    end
  end
end
