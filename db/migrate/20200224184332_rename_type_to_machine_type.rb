class RenameTypeToMachineType < ActiveRecord::Migration[6.0]
  def change
    rename_column :siege_machines, :type, :siege_machine_type
  end
end
