class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.integer :attachmentable_id
      t.string :attachmentable_type
      t.string :file

      t.timestamps
    end

    add_index :attachments, [:attachmentable_id, :attachmentable_type]
  end
end
