class CreateCharacterActions < ActiveRecord::Migration[6.0]
  def change
    create_table :character_actions, id: :uuid do |t|
      t.string :camp_id
      t.string :character_id
      t.string :action_type
      t.json :action_params
      t.string :target_id
      t.string :target_type

      t.timestamps
    end
  end
end
