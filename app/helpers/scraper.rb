module Scraper

	def search_artist(artist)
		agent = Mechanize.new
		artist = artist.gsub(' ', '')
		artist_url = artist[0] + '/' + artist + '.html'

		page = agent.get('http://azlyrics.com/' + artist_url)
		song_links = page.links_with(href: /lyrics\/#{artist}/)
		
		song_links.each do |link|
			parse_song(link)
		end
	end

	def parse_song(link)
		page = link.click
		lyrics = page.css('div.ringtone~div')[0].children
		
		# lyrics.each do |line|
		# 	parse_line(line)
		# end
	end

	def parse_line(line)
		puts line
	end

end
