class CreateTvCredits < ActiveRecord::Migration[5.2]
  def change
    create_table :tv_credits, :id => false do |t|
      t.primary_key :tv_credit_id, :null => false
      t.references :tv
      t.references :person
      t.string :role

      t.timestamps
    end
    add_index :tv_credits, [:tv_id, :person_id], :unique => true, :name => :tv_person_match
  end
end
