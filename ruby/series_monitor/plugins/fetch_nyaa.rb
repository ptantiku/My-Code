class FetchNyaa < FetchSite

	def initialize
		super(url:'http://www.nyaa.eu')
	end

	def fetch(keywords)
		
	    response = fetch_url()
	    return [] if response.nil?

	    results = []
	    response.scan(%r{class="tlistname">[^<]*<a href="([^">]*)"[^>]*>([^<]*)</a>}) do |link,title|
	 		#remove unnecessary data in brackets
	   		cleaned_title = title.gsub(/\[[^\]]*\]/,'').gsub(/\([^)]*\)/,'')
			#replace html unicode with real character
			cleaned_title = cleaned_title.gsub('&#38;','&').gsub('&#40;','(').gsub('&#41;',')')
			cleaned_link = link.gsub('&#38;','&').gsub('&#40;','(').gsub('&#41;',')')
	    	keywords.each do |keyword|
	    		if cleaned_title =~ Regexp.new(keyword,true) #case insensitive
	    			results << {title: title, link: cleaned_link}
	    		end
	    	end
		end
	    return results
	end
end
