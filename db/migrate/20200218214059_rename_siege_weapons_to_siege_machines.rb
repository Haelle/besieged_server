class RenameSiegeWeaponsToSiegeMachines < ActiveRecord::Migration[6.0]
  def self.up
    rename_table :siege_weapons, :siege_machines
  end

  def self.down
    rename_table :siege_machines, :siege_weapons
  end
end
