class FetchSite
	
	def initialize(input_hash={})
		@url = input_hash.fetch(:url, 'www.google.com')
	end

	def fetch_url(url=nil)
		url = @url if url.nil? 

		#format url if needed
		url = 'http://'+url if url !~ %r{^(http|https)://}
		
		puts "Fetching #{url}" if $debug

		open(url) do |stream|
			response = stream.read

			if $debug	# for debug
				puts "Loading from: #{stream.base_uri}"
				puts "\t Content Type: #{stream.content_type}\n"
		    	puts "\t Charset: #{stream.charset}\n"
		    	puts "\t Content-Encoding: #{stream.content_encoding}\n"
		    	puts "\t Last Modified: #{stream.last_modified}\n\n"
		    	puts "\t #{response}\n\n"
	    	end

	    	#return
	    	return response
	    end
	end
end