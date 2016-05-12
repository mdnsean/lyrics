class ArtistsController < ApplicationController
    def search
        # in routes.rb: add [POST] /artists/search?artist=
        @wc_data = Artist.get_wordcounts(params[:artist])
        # in home.html.erb: render counts_data
    end

    private
        def artist_params
            params.require(:artist).permit(:name)
        end
end
