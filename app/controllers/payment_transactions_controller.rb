class PaymentTransactionsController < ApplicationController
  def new
    @payment_transaction = PaymentTransaction.new
    @subjects = ::PaymentTransactionHelper::Transaction.new.valid_subjects(current_user)
  end

  def create
    @payment_transaction = PaymentTransaction.new
    result = ::PaymentTransactionHelper::Transaction.new.create(current_user.subject, params[:payment_transaction])
  rescue PaymentTransactionHelper::BalanceTooLow => e
    flash[:alert] = "An error occurred: #{e.message}"
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "An error occurred: #{e.message}"
  ensure
    redirect_to dashboard_path
  end
end
