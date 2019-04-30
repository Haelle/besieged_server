class RenameWeaponDamage < ActiveRecord::Migration[5.2]
  def change
    rename_column :siege_weapons, :damage, :damages
  end
end
