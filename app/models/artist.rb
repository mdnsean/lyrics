class Artist < ActiveRecord::Base
    has_many :wordcounts
    validates :name, presence: true

    before_create :normalize_name

    def normalize_name
        self.name = self.name.downcase.gsub(/\s/, ' ')
    end

    def display_word_counts(artist)
        # add artist to db
        if !Artist.where(name: artist).exists?
            search_genius(artist)
        end
        
        #  return SQL query: [counts.select(word,count).where(artist_id = a_id and 
        # .order(count))] as counts_data

    def search_genius(artist)
        agent = Mechanize.new
        artist_url = artist.gsub(' ', '-')

        # try this, if it fails, return empty
        page = agent.get('http://www.genius.com/artists/' + artist_url)

        # if it works, create new Artist, save a_id in a variable vv

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
        puts counts


        #for counts.each do |word, count|
            # SQL insert: word_counts.new(artist_id, word, count)

    end

end
