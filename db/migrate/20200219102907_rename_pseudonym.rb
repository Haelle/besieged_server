class RenamePseudonym < ActiveRecord::Migration[6.0]
  def change
    rename_column :characters, :pseudonyme, :pseudonym
  end
end
