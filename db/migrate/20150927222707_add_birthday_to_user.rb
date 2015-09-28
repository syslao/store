class AddBirthdayToUser < ActiveRecord::Migration
  def change
    add_column :users, :birthday, :integer
  end
end
