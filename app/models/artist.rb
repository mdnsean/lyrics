class Artist < ActiveRecord::Base
    has_many :wordcounts
    validates :name, presence: true, uniqueness: true

    def normalize_name(name)
        name = name.downcase.gsub(/\s+/, ' ')
    end

    def get_wordcounts(artist)
        artist = normalize_name(artist)
        if !Artist.where(name: artist).exists?
            search_genius(artist)
        end
        a_id = Artist.select('id').where(name: artist)
        Wordcount.select('word, count').where(artist_id: a_id).order(count: :desc)
    end

    def search_genius(artist)
        agent = Mechanize.new
        artist_url = artist.gsub(' ', '-')

        begin
            page = agent.get('http://www.genius.com/artists/' + artist_url)
        rescue Mechanize::ResponseCodeError
            puts 'Artist not found'
            return
        end

        # if it works, create new Artist, save a_id in a variable vv
        a = Artist.where(name: artist)[0]
        if !a.nil?
        	puts 'Artist already exists'
        else
	        a = Artist.new(name: artist)
	        begin
	            a.save
	            puts 'Artist saved: ' + artist
	        rescue ActiveRecord::RecordNotUnique
	            puts 'Already saved: ' + artist
	        end
        end
        puts 'artist_id = ' + a.id.to_s
        # return # just 4 debug

        pagination_links = page.links_with(href: /for_artist_page/)
        pagination_links.each do |link|
            link.click
        end

        song_links = page.links_with(href: /#{artist_url}.+lyrics/i)
        # only clicks first song (for now)
        song = song_links[0].click
        lyrics = song.css('p')[0].text.downcase.gsub(/\[.*\]/, '')
        word_array = lyrics.split(/\s+/)

        counts = {}
        word_array.each do |word|
        	word = word.gsub(/\W/, '')
            if counts[word]
                counts[word] += 1
            else
                counts[word] = 1
            end
        end
        puts counts
        insert_wordcounts(a, counts)
    end

    def insert_wordcounts(artist, counts_hash)
		counts_hash.each do |word, count|
            w = Wordcount.new(word: word, count: count)
            w.artist = artist
			begin
	            w.save
	            puts 'Saved word: ' + word + ', count: ' + count.to_s
	        rescue ActiveRecord::RecordNotUnique
	            puts 'Already saved: ' + word + ', count: ' + count.to_s
	        end
        end
    end
end
