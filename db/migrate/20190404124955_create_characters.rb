class CreateCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :characters, id: :uuid do |t|
      t.string :pseudonyme

      t.timestamps
    end
  end
end
