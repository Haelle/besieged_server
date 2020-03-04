class CreateBuildings < ActiveRecord::Migration[6.0]
  def change
    create_table :buildings, id: :uuid do |t|
      t.string :building_type
      t.belongs_to :camp, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
