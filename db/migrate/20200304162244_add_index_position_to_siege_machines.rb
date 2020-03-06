class AddIndexPositionToSiegeMachines < ActiveRecord::Migration[6.0]
  def change
    add_column :siege_machines, :position, :integer
  end
end
