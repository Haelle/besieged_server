class AddForeignKeyCharacters < ActiveRecord::Migration[5.2]
  def change
    change_table :characters do |t|
      t.belongs_to :account, type: :uuid, foreign_key: true
    end
  end
end
