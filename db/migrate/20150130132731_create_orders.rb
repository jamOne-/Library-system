class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.datetime :expiration
      t.string :order_type

      t.timestamps null: false
    end
  end
end
