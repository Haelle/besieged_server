class CreateSiegeWeapons < ActiveRecord::Migration[5.2]
  def change
    create_table :siege_weapons, id: :uuid do |t|
      t.integer :damage

      t.timestamps
    end
  end
end
