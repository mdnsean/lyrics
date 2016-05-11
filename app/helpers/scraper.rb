module Scraper

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
