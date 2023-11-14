class CreatePaymentTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_transactions do |t|
      t.float :amount
      t.string :transaction_type
      t.datetime :transaction_time
      t.string :notes

      t.references :subject, null: false, foreign_key: true
      t.timestamps
    end
  end
end
