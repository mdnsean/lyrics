module Scraper

	def search_genius(artist)
		agent = Mechanize.new
		artist_url = artist.gsub(' ', '-')

		page = agent.get('http://www.genius.com/artists/' + artist_url)
		pagination_links = page.links_with(css: '.more')
		paginations_links.each do |link|
			link.click
		end

		song_links = page.links_with(href: /#{artist_url}.+lyrics/i)
	end

			# document.getElementsByClassName('pagination')[0].firstChild.click()
# TypeError: document.getElementsByClassName(...)[0] is undefined

# paginate = page.css('div.pagination a').length
 # => 9 

	def search_azlyrics(artist)
		agent = Mechanize.new
		artist = artist.gsub(' ', '')
		artist_url = artist[0] + '/' + artist + '.html'

		page = agent.get('http://azlyrics.com/' + artist_url)
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
