class AddArtistIdtoWordcount < ActiveRecord::Migration
  def change
  	add_foreign_key :wordcounts, :artists
  end
end
