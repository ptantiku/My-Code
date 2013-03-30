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
	    	keywords.each do |keyword|
	    		if cleaned_title =~ Regexp.new(keyword,true) #case insensitive
	    			results << {title: title, link: link}
	    		end
	    	end
		end
	    return results
	end
end
