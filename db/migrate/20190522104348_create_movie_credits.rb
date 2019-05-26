class CreateMovieCredits < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_credits, :id => false do |t|
      t.primary_key :movie_credit_id, :null => false
      t.references :movie
      t.references :person
      t.string :role

      t.timestamps
    end
    add_index :movie_credits, [:movie_id, :person_id], :unique => true, :name => :movie_person_match
  end
end
