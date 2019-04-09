class CreateCastles < ActiveRecord::Migration[5.2]
  def change
    create_table :castles, id: :uuid do |t|
      t.integer :health_points
      t.belongs_to :camp, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
