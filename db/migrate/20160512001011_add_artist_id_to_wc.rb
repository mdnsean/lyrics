class AddArtistIdToWc < ActiveRecord::Migration
  def change
  	add_column :wordcounts, :artist_id, :integer
  end
end
