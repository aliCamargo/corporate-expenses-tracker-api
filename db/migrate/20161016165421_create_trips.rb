class CreateTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :trips do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :description
      t.decimal :budget, default: 0.0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
