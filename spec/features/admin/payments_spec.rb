require 'spec_helper'

feature "admin/payments" do
  given!(:user) { create :staff_user }

  background { sign_in user }

  feature "admin views payments", js: true do
    let!(:payments) { 3.times.map { create :transaction_payment } }
    let!(:debit) { create :transaction }

    scenario do
      visit admin_payments_path

      payments.each do |payment|
        expect(page).to have_content(payment.reference)
      end

      expect(page).to_not have_content(debit.reference)
    end
  end
end