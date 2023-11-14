module PaymentTransactionHelper
  class BalanceTooLow < StandardError
    def initialize(message = 'Balance is too low.')
      super(message)
    end
  end

  class Transaction
    def valid_subjects(user)
      Subject.where.not(subject_id: user.subject.id)
    end

    def check_balance(subject, amount)
      current_balance = calculate_balance(subject.payment_transactions)

      raise BalanceTooLow if current_balance < amount.to_f

      true
    end

    def withdraw(subject, params)
      check_balance(subject, params[:amount])

      ActiveRecord::Base.transaction do
        my_transaction = PaymentTransaction.new
        my_transaction.subject_id = subject.id
        my_transaction.amount = params[:amount]
        my_transaction.transaction_type = 'debit'
        my_transaction.transaction_time = Time.now
        my_transaction.notes = "Withdraw"
        my_transaction.save!
        my_transaction
      end
    end

    def deposit(subject, params)
      ActiveRecord::Base.transaction do
        my_transaction = PaymentTransaction.new
        my_transaction.subject_id = subject.id
        my_transaction.amount = params[:amount]
        my_transaction.transaction_type = 'credit'
        my_transaction.transaction_time = Time.now
        my_transaction.notes = "Deposit"
        my_transaction.save!
        my_transaction
      end
    end

    def create(subject, params)
      check_balance(subject, params[:amount])

      ActiveRecord::Base.transaction do
        target_subject = Subject.find(params[:subject_id])

        my_transaction = PaymentTransaction.new
        my_transaction.subject_id = subject.id
        my_transaction.amount = params[:amount]
        my_transaction.transaction_type = 'debit'
        my_transaction.transaction_time = Time.now
        my_transaction.notes = "Transfer to #{target_subject.name}"
        my_transaction.save!

        target_transaction = PaymentTransaction.new
        target_transaction.subject_id = target_subject.id
        target_transaction.amount = params[:amount]
        target_transaction.transaction_type = 'credit'
        target_transaction.transaction_time = Time.now
        target_transaction.notes = "Receives from #{subject.name}"
        target_transaction.save!

        my_transaction
      end
    end

    def calculate_balance(transactions)
      transactions.sum do |transaction|
        if transaction.transaction_type == 'debit'
          -transaction.amount
        elsif transaction.transaction_type == 'credit'
          transaction.amount
        else
          0
        end
      end
    end
  end
end
