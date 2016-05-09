module Scraper

	def search_artist(artist)
		agent = Mechanize.new
		artist = artist.gsub(' ', '')
		artist_url = artist[0] + '/' + artist + '.html'

		page = agent.get('https://azlyrics.com/' + artist_url)
		song_links = page.links_with(href: /lyrics\/#{artist}/)
		
		# parse_song(song_links[0])

		# song_links.each do |link|
		# 	parse_song(link)
		# end
	end

	def parse_song(link)
		page = link.click
		lyrics = page.css('div.ringtone~div')[0].children
		
		# parse_line(lyrics[0])
		
		# lyrics.each do |line|
		# 	parse_line(line)
		# end
	end

	def parse_line(line)
		puts line
	end

end
