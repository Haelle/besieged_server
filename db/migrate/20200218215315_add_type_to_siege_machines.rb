class AddTypeToSiegeMachines < ActiveRecord::Migration[6.0]
  def change
    add_column :siege_machines, :type, :string
  end
end
