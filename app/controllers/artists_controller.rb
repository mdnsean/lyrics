class ArtistsController < ApplicationController
    
    def index
    	@artists = Artist.all
    end

    def show
        @fav_words = Wordcount.select('word, count').
                     where('artist_id = ?', params[:id]).
                     order(count: :desc)
        # @fav_words = Wordcount.select('word, count').
        #            where('artist_id = ? and length(word) >= ?',
        #            params[:id], params[:min].to_i).
        #            order(count: :desc).limit(8)
        # @longest_words = Wordcount.where(artist_id: params[:id]).
        #            order('length(word) desc').limit(8)
        @artist = Artist.where(id: params[:id])[0]
        render json: {fav_words: @fav_words,
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
