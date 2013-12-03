class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.string :payment_type, :null => false, :default => 'single'
      t.datetime :payment_date, :null => true, :default => nil

      t.timestamps
    end

    add_index :payments, :user_id, :unique => true
  end
end
