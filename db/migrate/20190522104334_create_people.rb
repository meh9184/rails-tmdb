class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people, :id => false do |t|
      t.primary_key :person_id, :null => false
      t.string :name
      t.string :job
      t.string :birthday
      t.text :biography
      t.string :profile_path

      t.timestamps
    end
  end
end
