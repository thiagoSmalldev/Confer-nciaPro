class CreateLectures < ActiveRecord::Migration[7.1]
  def change
    create_table :lectures do |t|
      t.string :name
      t.integer :duration

      t.timestamps
    end
  end
end
