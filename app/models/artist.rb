class Artist < ActiveRecord::Base
    has_many :wordcounts, dependent: :destroy
    validates :name, presence: true, uniqueness: true

    def self.normalize_name(name)
        name = name.downcase.gsub(/\s+/, ' ')
    end

    def self.get_wordcounts(artist)
        artist = normalize_name(artist)
        if !Artist.where(name: artist).exists?
            search_genius(artist)
        else
            return
        end
        # a_id = Artist.select('id').where(name: artist)
        # Wordcount.select('word, count').where(artist_id: a_id).order(count: :desc)
    end

    def self.search_genius(artist)

        # Find artist page
        agent = Mechanize.new
        artist_url = artist.gsub(' ', '-')
        begin
            page = agent.get('http://www.genius.com/artists/' + artist_url)
        rescue Mechanize::ResponseCodeError
            puts 'Artist not found'
            return
        end

        # Show entire page
        pagination_links = page.links_with(href: /for_artist_page/)
        pagination_links.each do |link|
            link.click
        end

        # Add new artist to database
        artist_object = create_artist(artist)

        # Click all song links
        song_links = page.links_with(href: /#{artist_url}.+lyrics/i)
        scrape_all_song_links(artist_object, artist, song_links, 4)
    end

    def self.create_artist(artist)
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
        return a
    end

    def self.scrape_all_song_links(artist_object, artist, song_links, range)
        puts "song links = " + song_links.to_s
        
        # Scrape all songs from {0...range}
        song_links[0...range].each do |link|
            song = link.click
            lyrics = song.css('p')[0].text.downcase.gsub(/\[.*\]/, '')
            word_array = lyrics.split(/\s+/) # find lyrics on page
            
            counts_hash = {} # count this song's word frequencies
            word_array.each do |word|
                word = word.gsub(/\W/, '')
                if counts_hash[word]
                    counts_hash[word] += 1
                else
                    counts_hash[word] = 1
                end
            end
            puts counts_hash

            # Add WC's to database
            insert_wordcounts(artist_object, counts_hash)
        end
    end

    def self.insert_wordcounts(artist_object, counts_hash)
		counts_hash.each do |word, count|
            w = Wordcount.where(word: word, artist_id: artist_object.id)[0]
            if !w.nil?
                w.count += count
            else
                w = Wordcount.new(word: word, count: count)
                w.artist = artist_object
			end

            begin
	            w.save
	            puts 'Saved word: ' + word + ', count: ' + count.to_s
	        rescue ActiveRecord::RecordNotUnique
	            puts 'Already saved: ' + word + ', count: ' + count.to_s
	        end
        end
    end
end
