class ArtistsController < ApplicationController
    
    def index
    	@artists = Artist.all
    end

    def show
        @wc_data = Wordcount.select('word, count').
                   where(artist_id: params[:id]).
                   order(count: :desc)
        render json: {wc_data: @wc_data}
    end

    def search
        Artist.get_wordcounts(params[:name])
        @a_id = Artist.select('id').where(name: params[:name])
        @wc_data = Wordcount.select('word, count').
                   where(artist_id: @a_id).
         		   order(count: :desc)
    end

    private
        def artist_params
            params.require(:artist).permit(:name)
        end
end
