class AddNamesToWeapons < ActiveRecord::Migration[5.2]
  def change
    add_column :siege_weapons, :name, :string
  end
end
