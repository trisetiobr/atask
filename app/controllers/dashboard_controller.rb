# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  def index
    @user = current_user
    @subject = @user.subject
    @payment_transactions = @subject.payment_transactions.order(id: :desc)
    @balance = ::PaymentTransactionHelper::Transaction.new.calculate_balance(@payment_transactions)
  end
end
