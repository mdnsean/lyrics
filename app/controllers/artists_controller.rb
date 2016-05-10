class ArtistsController < ApplicationController
    def create
        # only if artist NOT in SQL, and found in genius
        @artist = Artist.new(artist_params)
    end

    private
        def artist_params
            params.require(:artist).permit(:name)
        end
end
