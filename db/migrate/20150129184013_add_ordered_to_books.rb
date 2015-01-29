class AddOrderedToBooks < ActiveRecord::Migration
  def change
    add_column :books, :ordered, :boolean, default: false
  end
end
