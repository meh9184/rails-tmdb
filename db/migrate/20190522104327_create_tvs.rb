class CreateTvs < ActiveRecord::Migration[5.2]
  def change
    create_table :tvs, :id => false do |t|
      t.primary_key :tv_id, :null => false
      t.string :name
      t.float :rating
      t.text :overview
      t.string :poster_path

      t.timestamps
    end
  end
end
