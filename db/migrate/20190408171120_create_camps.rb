class CreateCamps < ActiveRecord::Migration[5.2]
  def change
    create_table :camps, id: :uuid do |t|

      t.timestamps
    end

    change_table :characters do |t|
      t.belongs_to :camp, type: :uuid
    end

    change_table :siege_weapons do |t|
      t.belongs_to :camp, type: :uuid
    end
  end
end
