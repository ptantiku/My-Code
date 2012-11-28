class FetchEztv < FetchSite

	def initialize
		super(url:'http://www.eztv.it')
	end

	def fetch(keywords)
		
	    response = fetch_url()
	    return [] if response.nil?

	    results = []
	    response.scan(%r{class="epinfo">([^<]*)</a>[^<]*</td>[^<]*<td[^>]*>[^<]*<a href="(magnet:[^"]*)"}) do |title,link|
	    	keywords.each do |keyword|
	    		if title =~ Regexp.new(keyword,true) #case insensitive
	    			results << {title: title, link: link}
	    		end
	    	end
		end
=begin	
		url = 'www.ezrss.it/feed/'    
		doc = REXML::Document.new(response)
		doc.elements.each('*/tr[class="forum_header_bolder"]') do |item|
			puts item.to_s
			title = item.elements['title'].text
			keywords.each do |keyword|
				if title =~ Regexp.new(keyword,true) #case insensitive
					magneturi = item.elements['*/magnetURI'].text
					results << {title: title, link: magneturi}
				end
			end

		end
=end
	    return results
	end
end
