module Scraper

    def search_genius(artist)
        agent = Mechanize.new
        artist_url = artist.gsub(' ', '-')

        page = agent.get('http://www.genius.com/artists/' + artist_url)
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

    end

    def search_azlyrics(artist)
        agent = Mechanize.new
        artist = artist.gsub(' ', '')
        artist_url = artist[0] + '/' + artist + '.html'

        page = agent.get('http://azlyrics.com/' + artist_url)
        song_links = page.links_with(href: /lyrics\/#{artist}/)

        song = song_links[0].click
        lyrics = song.css('div.ringtone~div')[0].children

        lyrics.each do |line|
        end
    end
end
