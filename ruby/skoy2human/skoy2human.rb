#!/usr/bin/env ruby
# encoding: utf-8

# Skoy2Human for translating between Skoy language and human language
# แปลงภาษาสก๊อยให้เป็นภาษามนุษย์(ภาษาไทย)
# author anidear

# original author NarZe
# original source code in Javascript at https://github.com/NarzE/toSkoy/blob/master/toskoy.js

class Skoy2Human
    @@db = Hash.new
    
    def initialize()
        learn(Hash[
            'ุ๊'=>'ู',
            'ญ'=>'ย',
            '๊'=>'ะ',
            'ฎ'=>'ด',
            'ฏ'=>'ต',
            'ฆ'=>'ข',
            'ฮ'=>'อ',
            'ธ'=>'ท',
            'ิ๊'=>'ี',
            '๊'=>'้',
            'ณ'=>'น',
            'ภ'=>'พ',
            'พ'=>'ภ',
            '๊'=>'า',
            'ช๋'=>'ฉ',
            'นุ๊วซ์'=>'หนุ',
            'ญั๊ข'=>'อยาก',
            'ขร๊'=>'คะ',
            'ฆร่'=>'ค่ะ',
            'ัล'=>'ัน',
            '๊ก'=>'วก',
            'พ๊ก,คุ๊ล,จ่,ว่,อ่,รั๊ย,ก่,เซิฬ,เร่ย,น๊,พ๊ก,เลา,ไม๊,ส่น,หร่อก' => 
	    'พวก,คุณ,จะ,ว่า,อะ,ไร,ก็,เชิญ,เลย,นะ,พวก,เรา,ไม่,สน,หรอก',
            'มริ๊,ณิ๊,ธาง์ร,ม่,เฬอ่า,หั๊ล์ย,พริ๊ต์,ฟรั๊ก์ง,ค๊,ณิ๊,ธาถ์ฯ,เฬอื่บ์ลง,ณิ๊,ศั๊ฎ์,ญหั๊ล์,รุ๊ง์ว,ว่,ชั๊ส์ว,ณฆ์า,กั๊ผ,ฑะ,เฬ,ธิ๊ฆ์,หค์ก,นุ๊ซ์ว' =>
            'มี,นิ,ทาน,มา,เล่า,ให้,พี่,ฟัง,คะ,นิ,ทาน,เรื่อง,นี้,สอน,ให้,รู้,ว่า,ชาว,นา,กับ,ทะ,เล,ที่,หก,หนู',
            'กั๊รฬว์ะ,ฅั๊ฐ์งหสุ์,ณึ่,ชั๊ย์ว,ณฆ์า,กั๊,ร์ฬ,ห๊ษ์า,ปธ์ฬา,ยุ๊ว์ซ,นั๊บ์ย,ต่,ว๊พ์,ห๊ษ์า,ญั๊ล์ง,งั๊.,กํ,มรั๊ล์ย,เ๗อ,ชั๊ซ์ว,ณษ์า,ก่,เร่รร,ปั๊บ์ย' =>
            'กาล,ครั้ง,หนึง,ชาว,นา,กำ,ลัง,หา,ปลา,อยู่,ใน,แต่,ว่า,หา,ยัง,ไง,ก็,ไม่,เจอ,ชาว,นา,ก็,เลย,ไป',            
	    'ธั๊ญ,ก่,ฆี่,ดั๊ย์ย,เภีซ์ย.,แฆ่,ชั๊,ม๊ษ,วั๊ล์ว,ฆุวญ,นุ๊ซ์ว,ดั๊ย,เฅ๋ย,บั๊ว์ก,ปั๊ญ,เร๊ว,ว๊,หั๊ว์ก,ภุ๊ว,ดั๊ญ,ม่,มริ๊,นุ๊ซ์ว,ม่,หั๊ญ์ย,จีผ,หั๊ส์ก,ธั๊ญ,ภ๋ฮ,จั๊ญย์,นั๊ล,ตั๊ซ์ว,นุ๊ว,นุ๊ว,ฅฮ,เแน่๊ะ,ณรรม,หั๊ยฐ์,ธั๊ฯ,ปั๊ย,ห๊,มษ,วั๊ญ,ฆี่,ษ๊ะ' =>
	    'ท่าน,ก็,ขี่,ได้,เพียง,แค่,ช้าง,ม้า,วัว,ควาย,หนู,ได้,เคย,บอก,ไป,แล้ว,ว่า,หาก,ผู้,ใด,ไม่,มี,หนู,ไม่,ให้,จีบ,หาก,ท่าน,พอ,ใจ,ใน,ตัว,หนู,หนู,ขอ,แนะ,นำ,ให้,ท่าน,ไป,หา,มา,ไว้,ขี่,ซะ',
            'หั๊ฆ,แม๊ร์น,ธั๊ณ,ห่ร์า,ม่,ฅี่,ดั๊ย์ญ,เร๊ว์ว,ต่,ธั๊ฯ,ญั๊.ง,แฏ่ง,ฏัซ์ว,มั๊ญ์ย,ฑั๊น,ษมั๊ย์ญ,)าก,ซี๊จ,ฟรั๊ญ,ดรรว์ม,ยุ๊ซ์ว,บั๊บ,นี๊,เวฬฬา,จุ้ผ,กั๊ล์ณ,นุ๊ซ์ว,ฅ๊ง,จ่,มั๊ญ์ย,)ลืม,แณ์ร์,ข่บ,คุ๊ฯ,คร๊' =>
	    'หาก,แม้น,ท่าน,หา,มา,ขี่,ได้,แล้ว,แต่,ท่าน,ยัง,แต่ง,ตัว,ไม่,ทัน,สมัย,ปาก,ซีด,ฟัน,ดำ,อยู่,แบบ,นี้,เวลา,จุ๊บ,กัน,หนู,คง,จะ,ไม่,ปลื้ม,แน่,ขอบ,คุณ,ค่ะ'
            ])
            # https://www.facebook.com/sowhateiei/posts/333737343378863
	    # https://www.facebook.com/lordofsiam/posts/343845539024385
	
	  puts "#{@@db.size} words is loaded in database"
    end
        
    def learn(obj)
        if obj.is_a?(Hash)
            obj.each do |from,to|
               if from =~ /,/ and to=~ /,/     #could be phrase
                    from_array = from.split(/,/)
                    to_array = to.split(/,/)
                    if from_array.size == to_array.size
                        @@db.merge!(Hash[*from_array.zip(to_array).flatten])
                    else
                        raise 'count mismatch!'
                    end
                else
                    @@db[from] = to
                end
            end
        end
    end
    
    def to_human(str)
        #duplicate variable, so we can what's inside
        str = str.clone
        
        # find max from_word in DB
        max_from_word = @@db.keys.map{|s| s.length}.max
        
        i=0
        while i<str.length
            matched = false
            # try to translate with longest word first
            max_from_word.downto(1).each do |j|
                next if (i+j-1) >= str.length  # do not go into the loop
                from = str[i,j]
                if @@db.has_key?(from)
                    to = @@db[from]
                    #puts "==> translate #{from} to #{to}"
                    str[i,j] = to
                    i += to.length
                    matched = true
                    break
                end
            end
            i+=1 if !matched
        end
        str
    end
    
    def to_skoy(str)
        #duplicate variable, so we can what's inside
        str = str.clone
        
        # find max from_word in DB
        max_to_word = @@db.values.map{|s| s.length}.max
        
        i=0
        while i<str.length
            matched = false
            # try to translate with longest word first
            max_to_word.downto(1).each do |j|
	       #puts "j=#{j}: '#{str[i,j]}'"
                next if (i+j-1) >= str.length  # do not go into the loop
                to = str[i,j]
                if @@db.has_value?(to)
                    from = @@db.key(to)
                    #puts "==> translate #{to} to #{from}"
                    str[i,j] = from
                    i += from.length
                    matched = true
                    break
                end
            end
            i+=1 if !matched
        end
        str
    end
end

# main
skoy2human = Skoy2Human.new
input = ''
while input!='exit'
    print 'input word >'
    input = gets.chomp
    if input!='exit'
        # to skoy
        skoy_word = skoy2human.to_skoy(input)
        puts "To skoy ===> #{skoy_word}"
        
        # to human
        human_word = skoy2human.to_human(input)
        puts "To human ===> #{human_word}"
    end
end

