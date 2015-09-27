class AddAttachmentUserPasportToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :user_pasport
    end
  end

  def self.down
    remove_attachment :users, :user_pasport
  end
end
