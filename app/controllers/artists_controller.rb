class ArtistsController < ApplicationController
    def search
        # in routes.rb: add [POST] /artists/search

        # @counts_data = [artist.rb stuff]
        # in home.html.erb: render counts_data
    end

    private
        def artist_params
            params.require(:artist).permit(:name)
        end
end
