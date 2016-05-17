class ArtistsController < ApplicationController
    
    def index
    	@artists = Artist.all
    end

    def show
        @wc_data = Wordcount.select('word, count').
                   where(artist_id: params[:id]).
                   order(count: :desc).limit(8)
        @artist = Artist.where(id: params[:id])[0]
        render json: {wc_data: @wc_data,
                      artist: @artist}
    end

    def search
        if Artist.get_wordcounts(params[:name]).nil?
            flash[:notice] = "Artist not found, or already in database"
        end
        redirect_to root_url
    end

    def destroy
        @artist = Artist.find(params[:id])
        @artist.destroy
        redirect_to root_url
    end

    private
        def artist_params
            params.require(:artist).permit(:name)
        end
end
