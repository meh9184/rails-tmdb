class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies, :id => false do |t|
      t.primary_key :movie_id, :null => false
      t.string :title
      t.float :rating
      t.text :overview
      t.string :poster_path

      t.timestamps
    end
  end
end
