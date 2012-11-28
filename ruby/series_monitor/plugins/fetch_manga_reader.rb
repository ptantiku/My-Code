
class FetchMangaReader < FetchSite

	def initialize
		super(url:'http://www.mangareader.net')
	end

	def fetch(keywords)
		
	    response = fetch_url()
	    return [] if response.nil?

	    results = []
	    response.scan(%r{class="chaptersrec" href="([^"]*)">([^<]*)</a>}) do |link,title|
	    	keywords.each do |keyword|
	    		if title =~ Regexp.new(keyword,true) #case insensitive
	    			link = "#{@url}#{link}" if link !~ /mangareader.net/i
	    			results << {title: title, link: link}
	    		end
	    	end
		end
		
	    return results
	end
end
