class CreateWordcounts < ActiveRecord::Migration
  def change
    create_table :wordcounts do |t|
      t.string :word
      t.integer :count

      t.timestamps null: false
    end
  end
end
