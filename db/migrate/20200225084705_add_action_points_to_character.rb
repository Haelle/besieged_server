class AddActionPointsToCharacter < ActiveRecord::Migration[6.0]
  def change
    add_column :characters, :action_points, :integer, default: 0
  end
end
