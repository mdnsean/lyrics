class UniqueWordCounts < ActiveRecord::Migration
  def change
	add_index :wordcounts, [:artist_id, :word], :unique => true
  end
end
