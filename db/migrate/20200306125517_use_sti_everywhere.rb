class UseStiEverywhere < ActiveRecord::Migration[6.0]
  def change
    rename_column :siege_machines, :siege_machine_type, :type
    rename_column :buildings, :building_type, :type
  end
end
