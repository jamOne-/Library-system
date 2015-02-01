class AddUserAndBookToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :user, index: true
    add_foreign_key :orders, :users
    add_reference :orders, :book, index: true
    add_foreign_key :orders, :books
  end
end
