class Artist < ActiveRecord::Base
    has_many :wordcounts
    validates :name, presence: true, uniqueness: true

    def normalize_name(name)
        name = name.downcase.gsub(/\s+/, ' ')
    end

    def get_word_counts(artist)
        artist = normalize_name(artist)
        # if !Artist.where(name: artist).exists?
            search_genius(artist)
        # end
        
        #  return SQL query: [counts.select(word,count).where(artist_id = a_id and 
        # .order(count))] as counts_data
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
	            puts 'Error saving'
	        end
        end
        artist_id = a.id
        puts 'artist_id = ' + artist_id.to_s
        return # just 4 debug

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
            if counts[word]
                counts[word] += 1
            else
                counts[word] = 1
            end
        end
        return counts

        # counts.each do |word, count|
            # w = wordcount.new
            # 
            # SQL insert: word_counts.new(artist_id, word, count)
        # end
    end
end
