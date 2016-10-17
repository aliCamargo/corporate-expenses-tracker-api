class CreateExpenses < ActiveRecord::Migration[5.0]
  def change
    create_table :expenses do |t|
      t.string :name
      t.decimal :value, default: 0
      t.text :note
      t.references :trip, foreign_key: true

      t.timestamps
    end
  end
end
