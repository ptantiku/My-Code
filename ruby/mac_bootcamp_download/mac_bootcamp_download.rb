#!/usr/bin/env ruby

# Author: Anidear (anidear1 {at} gmail {dot} com)
# My Blog: http://blog.anidear.com
# Credit: http://blog.timvalenta.com/2011/11/19/boot-camp-driver-downloads/

require 'net/http'
require 'uri'

MAC_UPDATE_URL = 'http://swscan.apple.com/content/catalogs/others/index-lion-snowleopard-leopard.merged-1.sucatalog'

mac_update_uri = URI(MAC_UPDATE_URL)
mac_update_xml = Net::HTTP.get(mac_update_uri)
dist_links = Hash.new
pkg_links = Hash.new
mac_update_xml.split("\n").each{|line|
    #search for 041-XXXX.English.dist or BootCampESD.pkg
    line.chomp.scan(%r{(http://[^<]*041-[^<]*\English.dist)|(http://[^<]*BootCampESD\.pkg)})
        .each{|link|
            link_url = (link[0].nil?)? link[1] : link[0] ;
            version = link_url.match(/041-[0-9]+/)[0]
            if (link[0].nil?)
                pkg_links[version] = link_url
            else
                dist_links[version] = link_url
            end
        }
}

#filter only .pkg presents
dist_links.select!{|key,val|
    pkg_links.key?(key) #keep dist_link if pkg_link presents
}

#for each of dist_links
#find something like 
# "var models = ['MacBookAir3,1','MacBookAir3,2',];"
list = dist_links.keys.sort
list.each{|key|
    val = dist_links[key]
    uri = URI(val)
    data = Net::HTTP.get(uri)

    res = data.match(/var models = \[(.*)\];/)
    if !(res[1].nil?)
        puts "Code: #{key}"
        res[1].scan(/'[^']*'/).each{|model|
            puts "\t[+] #{model}"
        }
        puts "Download Link:\n\t[+] #{pkg_links[key]}"
        puts
    end
}

# instruction
puts 'INSTRUCTIONS: '
puts '1. Go to "Apple menu" -> "About this Mac" -> "More Info…" -> "System Report..." -> "Hardware"'
puts '   to see what model your mac is.'
puts '2. Match your model with the download link above and download it'
puts '3. Use 7zip application to extract the pkg file'
puts '4. Browse to "Library/Application Support/BootCamp/" in the archive'
puts '5. Inside there is a file "WindowsSupport.dmg", also use 7zip to browse inside it'
puts '6. There is "0.Apple_ISO" file, rename it to have a proper .iso extension e.g. "BootCamp.iso"'
puts '7. Mount BootCamp.iso in Windows or burn it to a CD in order to use it.'
puts 'Have fun!'

