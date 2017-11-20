class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.date :start
      t.date :finish
      t.integer :progress
			t.string :dependencies
			t.string :custom_class
    end
  end
end
