class CreateOngoingTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :ongoing_tasks, id: :uuid do |t|
      t.string :type
      t.json :params
      t.integer :action_points_spent, default: 0
      t.integer :action_points_required, default: 1
      t.boolean :repeatable, default: false
      t.uuid :taskable_id
      t.string :taskable_type

      t.timestamps
    end

    add_index :ongoing_tasks, [:taskable_id, :taskable_type]
  end
end
