class AddOrderToBooks < ActiveRecord::Migration
  def change
    add_reference :books, :order, index: true
    add_foreign_key :books, :orders
  end
end
