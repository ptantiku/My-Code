#!/usr/bin/env ruby
# encoding: UTF-8

require 'anemone'

file = File.new("output.txt","w+")

Anemone.crawl(
	"http://pantip.com/cafe/all/list_topicAll.php?page=1",
	:depth_limit =>5,
#	:verbose=>true,
# 	:delay => 3
	) do |anemone|
	
	anemone.skip_links_like(/.*(jpg|gif|png)$/)
	
	anemone.focus_crawl { |page| 
		page.links.slice(0..20000) 
	}
	
	# anemone.on_every_page do |page|
	anemone.on_pages_like(/\.html$/) do |page|
		if page.html?
			begin
				puts page.url 
				doc = page.doc
				doc.encoding = 'utf-8'
				doc.css('script').remove #remove <script>
				doc.css('style').remove #remove <script>
				content = doc.content
				#remove symbols
				content.gsub!(/[[:punct:]]|[><|=+]/,' ')
				#remove engword && number
				content.gsub!(/\w+/,' ')
				#remove spaces
				content.gsub!(/[[:space:]]+/,' ')
				file.puts content
			rescue Exception=>e
				puts e
			end
		end
	end
end

file.close

# http://pantip.com/cafe/wahkor/listerX.php?
# http://pantip.com/cafe/religious/listerY.php?
# http://pantip.com/cafe/food/listerD.php?
# http://www.pantip.com/cafe/rajdumnern/listerP.php?
# http://pantip.com/cafe/siam/listerF.php?
# http://www.pantip.com/cafe/blueplanet/listerE.php?
# http://pantip.com/cafe/woman/listerQ.php?
# http://pantip.com/cafe/family/listerN.php?
# http://pantip.com/cafe/chalermthai/listerA.php?
# http://pantip.com/cafe/library/listerK.php?
# http://pantip.com/cafe/jatujak/listerJ.php?
# http://pantip.com/cafe/klaibann/listerH.php?
# http://pantip.com/cafe/chalermkrung/listerC.php?
# http://pantip.com/cafe/home/listerR.php?
# http://pantip.com/cafe/ratchada/listerV.php?
# http://pantip.com/cafe/silom/listerB.php?
# http://pantip.com/cafe/mbk/listerT.php?
# http://pantip.com/cafe/sinthorn/listerI.php?
# http://pantip.com/cafe/supachalasai/listerS.php?
# http://pantip.com/cafe/blueplanet/listerE.php?
# http://pantip.com/cafe/social/listerU.php?
# http://pantip.com/cafe/camera/listerO.php?
# http://pantip.com/cafe/isolate/listerM.php?
# http://pantip.com/cafe/lumpini/listerL.php?
# http://pantip.com/cafe/news/listerNE.php?
# http://pantip.com/cafe/all/list_topicAll.php?