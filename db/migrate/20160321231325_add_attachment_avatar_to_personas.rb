class AddAttachmentAvatarToPersonas < ActiveRecord::Migration
  def self.up
    change_table :personas do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :personas, :avatar
  end
end
