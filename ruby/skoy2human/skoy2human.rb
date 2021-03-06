#!/usr/bin/env ruby
# encoding: utf-8

###################################################################
# Skoy2Human                                                      #
# description:                                                    #
#   for translating between Skoy language and human language      #
#   แปลงภาษาสก๊อยให้เป็นภาษามนุษย์(ภาษาไทย)                            #
# author: ptantiku                                                #
#                                                                 #
# credit:                                                         #
#   This code is derived from Javascript code from                #
#   NarZe (https://github.com/NarzE/toSkoy/blob/master/toskoy.js) #
###################################################################

class Skoy2Human
    @@db = Hash.new
    
    def initialize()
        learn(
            Hash[
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
           
        # https://www.facebook.com/sowhateiei
        'พ๊ก,คุ๊ล,จ่,ว่,อ่,รั๊ย,ก่,เซิฬ,เร่ย,น๊,พ๊ก,เลา,ไม๊,ส่น,หร่อก' => 
        'พวก,คุณ,จะ,ว่า,อะ,ไร,ก็,เชิญ,เลย,นะ,พวก,เรา,ไม่,สน,หรอก',

        'นุ๊ล์ว,ม่,มริ๊,อ่ไฬ,จ่,ดพจ,อ๊'=>
        'หนู,ไม่,มี,อะไร,จะ,โพสต์,อ่ะ',

        'ษม่ค่ล์ม,นิ๋ญฒ,สก๊อย' => 
        'สมาคม,นิยม,สก๊อย',

        # https://www.facebook.com/lordofsiam/posts/343845539024385
        'ธั๊ญ,ก่,ฆี่,ดั๊ย์ย,เภีซ์ย.,แฆ่,ชั๊,ม๊ษ,วั๊ล์ว,ฆุวญ,นุ๊ซ์ว,ดั๊ย,เฅ๋ย,บั๊ว์ก,ปั๊ญ,เร๊ว,'+
        'ว๊,หั๊ว์ก,ภุ๊ว,ดั๊ญ,ม่,มริ๊,นุ๊ซ์ว,ม่,หั๊ญ์ย,จีผ,หั๊ส์ก,ธั๊ญ,ภ๋ฮ,จั๊ญย์,นั๊ล,ตั๊ซ์ว,นุ๊ว,นุ๊ว,'+
        'ฅฮ,เแน่๊ะ,ณรรม,หั๊ยฐ์,ธั๊ฯ,ปั๊ย,ห๊,มษ,วั๊ญ,ฆี่,ษ๊ะ' =>
        'ท่าน,ก็,ขี่,ได้,เพียง,แค่,ช้าง,ม้า,วัว,ควาย,หนู,ได้,เคย,บอก,ไป,แล้ว,'+
        'ว่า,หาก,ผู้,ใด,ไม่,มี,หนู,ไม่,ให้,จีบ,หาก,ท่าน,พอ,ใจ,ใน,ตัว,หนู,หนู,'+
        'ขอ,แนะ,นำ,ให้,ท่าน,ไป,หา,มา,ไว้,ขี่,ซะ',

        # https://www.facebook.com/lordofsiam/posts/343845539024385
        'หั๊ฆ,แม๊ร์น,ธั๊ณ,ห่ร์า,ม่,ฅี่,ดั๊ย์ญ,เร๊ว์ว,ต่,ธั๊ฯ,ญั๊.ง,แฏ่ง,ฏัซ์ว,มั๊ญ์ย,ฑั๊น,ษมั๊ย์ญ,)าก,ซี๊จ,'+
        'ฟรั๊ญ,ดรรว์ม,ยุ๊ซ์ว,บั๊บ,นี๊,เวฬฬา,จุ้ผ,กั๊ล์ณ,นุ๊ซ์ว,ฅ๊ง,จ่,มั๊ญ์ย,)ลืม,แณ์ร์,ข่บ,คุ๊ฯ,คร๊' =>
        'หาก,แม้น,ท่าน,หา,มา,ขี่,ได้,แล้ว,แต่,ท่าน,ยัง,แต่ง,ตัว,ไม่,ทัน,สมัย,ปาก,ซีด,'+
        'ฟัน,ดำ,อยู่,แบบ,นี้,เวลา,จุ๊บ,กัน,หนู,คง,จะ,ไม่,ปลื้ม,แน่,ขอบ,คุณ,ค่ะ',


        # https://www.facebook.com/sowhateiei/posts/333737343378863
        'นุ๊ซ์ว,มริ๊,ณิ๊ธาง์ร,ม่,เฬอ่า,หั๊ล์ย,พริ๊ต์,ฟรั๊ก์ง,ค๊,ณิ๊ธาถ์ฯ,เฬอื่บ์ลง,ณิ๊,ศั๊ฎ์ญ,หั๊ล์,รุ๊ง์ว,ว่,ชั๊ส์ว,ณฆ์า,กั๊ผ,ฑะเฬ,ธิ๊ฆ์,หค์ก,'+
        'กั๊ร,กั๊รฬว์ะฅั๊ฐ์ง,หสุ์ณึ่.,ชั๊ย์ว,ณฆ์า,กั๊ร์ฬ,ห๊ษ์า,ปธ์ฬา,ยุ๊ว์ซ,นั๊บ์ย,) ่าา,ต่,ว๊พ์,ห๊ษ์า,ญั๊ล์ง,งั๊.,กํ,มรั๊ล์ย,เ๗อ,ชั๊ซ์ว,ณษ์า,'+
        'ก่,เร่รร,ปั๊บ์ย,ห่,ปว์ฬา,ยุ๊ร์ล์ว,นั๊จ์ย,มุ๊.ค์,ต่,ว๊,ก๊,ญั๊ล์ง,ม่,เจร์ฮ,ชั๊ซ์ว,ณษ์า,ก่,เร่รร,กรั๊ผ,บั๊ฯ,ฎี,กวั๊ช์า,ภร์อ,ชั๊ญ์ว,ณษ์า,'+
        'กรั๊ผ,ฑึ๊.,บั๊ญ์น,ชั๊ส์ว,ณษ์า,๖๊ก,จั๊ล์ย,มั๊ฆ,เห๊ฯ,ณร๊ษ์ก,๖ก,ฬ.,ม่,ตั๊บ์ย,ชั๊ย์ว,ณษ์า,ก่,เร่รร,ภฎ์า,ณ๊ห์ก,ณ๊ฮ์อย,ธิ๊,น่,รั๊ช์ฆ,มั๊ฃ,'+
        'ตั๊ล์ว,นั๊พ์ณ,ปั๊ล์ย,ฒรรง์ม,บุ๊ร์ณ,ชั๊ซ์ว,ณษ์า,ฎั๊ล์ย,ปั๊ญ์ย,ห๋ธ์า,หรั๊ว์ง,ภ่ฮ์อ,ชั๊ส์ว,ณษ์า,๖๊ก,จั๊ล์ย,มั๊ฆ,ธิ๊ว์,เห้ฯ,หรั๊ว์ง,ภ่ฮ์อ,'+
        'กั๊ล์ม,ฬวั.,นั๊ล์ง,ฬอ้.,หั๊ล์ย, ชั๊ซ์ว,ณษ์า,เร่รร,เฃ๊ว์่า,ปั๊ญ์ย,ถั๊ว์ม,ว่,ธั๋ล์น,เ)้ฯ,อ่รั๊จ์ย,หรั๊ว์ง,ภ่ฮ์อ,ตั๊ว์บ,ม่,ว๊ห์า,'+
        'นุ๊ซ์ว,โโฯม่,มริ๊น์,บั๊ย์น,ยุ๊ซ์ว,ฆ๊,แง,ชั๊ย์ว,ณษ์,รุ๊ล์ว,ษึย์ก,ฉ๊.ฉั๊ล,ก่,เร่รรล์,ภล์า,หรั๊ว์ง,ภ่ฮ์อ,กรั๊ท์ผ,ม่,ธิ๊,บั๊ญ์น,ข่ง,ชั๊ซ์ว,ณษ์า,ดั๊ล์ว,'+
        'เร๊ย์ว,ชั๊ล์,ณษ์า,ก่,แฮ์อผ,หร๋.,รั๊ฅ,หยิ๋.,เฉว๋์า,ค๊ลฯ์,นิ๊ย์,ชั๊ล์ว,ณษ์า,ดั๊ล์ย,ขั๊บ์ย,บั๊น,ขั๊บ์ย,ฬฆเภืฮ์อ,จ่,ดั๊ล์ย,ปรั๊ง์ว,ซื๊ฉ์อ,'+
        'เฃ้ม์ก,แฏ่.,งั๊ธ์น,ภฑ์อ,ชั๊ส์ว,ณษ์า,เฮษ์ว,เฃ้พ์ก,ปั๊น์ญ,สรั๊ล์ย,ฏอู้,เญ๊ฯ,บั๊ล์ฯ,เร๊ฟ์ะ,ข่ง,ชั๊ซ์ว,ณษ์า,ดั๊ล์ย,ห่ษ์าย,ปั๊ล์ย,'+
        'ชั๊ซ์ว,ณษ์า,ง.,มั๊ฆ,ก่,เร่รร,วิ๊ล์ง,ฬอ้.,หั๊ล์ย,ปั๊ย์,ห๊ล์า,ญิ๋ว์ง,เฉฑ์า,ค๊ฯ,ณั๊ล์ญ,ญิ๋ว์ง,เฉฑ์า,ค๊ฯ,ณั๊ล์ญ,ฎั๊ล์ย,ตํ๊ผ,กรั๊ผ,ม่,ว๊ห์า,'+
        'ม่,เป๊ร์,รั๊ล์,น๊,เด๊ส์ว,จ่,ธั๊ฦ์ม,หั้ฐ์ย,ธด์ารณ์,หมั๊ย์ล,ภฮ์อ,วั๊ฯ,ฬอุ้.,ฅึ๊ณ,ญิ๋ล์ง,เฉ๋ฑ์า,ฃ๊ร์น,ณั๊ล์ญ,หั๊บ์ย,ปั๊ฎ์ย,ชั๊ว์า,ณษ์า,รุ๊ซ์ว,ษึ๊ฆ,งง,มั๊จ์ก,'+
        'อิ๊ฅ,ห๊น์ก,ศิ๊ผ,ปก์รี,ฏ่ฮ์อ,ม่,ชั๊ซ์ว,ณษ์า,ดั๊ล์ย,เษีร์ว์ย,ฉีว์พ์วิจ,ฬง,ณิ๊ธาง์ร,เฬอื่ลง,ณิ๊,มริ๊,เช่ฮ์อ,ว่,'+
        'กั๊ล์อณ,มริ๊,เภ๊ง์จ,ศั๊ล์มภั๊ย์ญ,คร์วญ,ศั๊ใล์ม,ถุ๊ล์ง,ยั๊ส์งฮ์,อณษ์ามั๊ล์ย,ข่บ,คุ๊น,ค๊' =>
        'หนู,มี,นิทาน,มา,เล่า,ให้,พี่,ฟัง,ค่ะ,นิทาน,เรื่อง,นี้,สอน,ให้,รู้,ว่า,ชาว,นา,กับ,ทะเล,ที่,หก,'+
        'กาล,กาลครั้ง,หนึ่ง,ชาว,นา,กำลัง,หา,ปลา,อยู่,ใน,นา,แต่,ว่า,หา,ยัง,ไง,ก็,ไม่,เจอ,ชาว,นา,'+
        'ก็,เลย,ไป,หา,ปลา,อยู่,ใน,มุ้ง,แต่,ว่า,ก็,ยัง,ไม่,เจอ,ชาว,นา,ก็,เลย,กลับ,บ้าน,ดี,กว่า,พอ,ชาว,นา,'+
        'กลับ,ถึง,บ้าน,ชาว,นา,ตก,ใจ,มาก,เห็น,นก,ตก,ลง,มา,ตาย,ชาว,นา,ก็,เลย,พา,นก,น้อย,ที่,น่า,รัก,มาก,'+
        'ตัว,นั้น,ไป,ทำ,บุญ,ชาว,นา,ได้,ไป,หา,หลวง,พ่อ,ชาว,นา,ตก,ใจ,มาก,ที่,เห็น,หลวง,พ่อ,'+
        'กำ,ลัง,นั่ง,ร้อง,ไห้,ชาว,นา,เลย,เข้า,ไป,ถาม,ว่า,ท่าน,เป็น,อะไร,หลวง,พ่อ,ตอบ,มา,ว่า,'+
        'หนู,ไม่,มี,บ้าน,อยู่,ค่ะ,แง,ชาว,นา,รู้,สึก,สงสาร,ก็,เลย,พา,หลวง,พ่อ,กลับ,มา,ที่,บ้าน,ของ,ชาว,นา,ด้วย,'+
        'แล้ว,ชาว,นา,ก็,แอบ,หลง,รัก,หญิง,สาว,คน,นี้,ชาว,นา,ได้,ขาย,บ้าน,ขาย,เรือน,จะ,ได้,ไป,ซื้อ,'+
        'เค้ก,แต่ง,งาน,พอ,ชาว,นา,เอา,เค้ก,ไป,ใส่,ตู้,เย็น,บ้าน,เล็ก,ของ,ชาว,นา,ได้,หาย,ไป,'+
        'ชาว,นา,งง,มาก,ก็,เลย,วิ่ง,ร้อง,ไห้,ไป,หา,หญิง,สาว,คน,นั้น,หญิง,สาว,คน,นั้น,ได้,ตอบ,กลับ,มา,ว่า,'+
        'ไม่,เป็น,ไร,นะ,เดี๋ยว,จะ,ทำ,ให้,ทาน,มัน,พอ,วัน,รุ่ง,ขึ้น,หญิง,สาว,คน,นั้น,ให้,ไป,ชาว,นา,รู้,สึก,งง,มาก,'+
        'อีก,หก,สิบ,ปี,ต่อ,มา,ชาว,นา,ได้,เสีย,ชีวิต,ลง,นิทาน,เรื่อง,นี้,มี,ชื่อ,ว่า,'+
        'ก่อน,มี,เพศ,สัมพันธ์,ควร,ใส่,ถุง,ยาง,อนามัย,ขอบ,คุณ,ค่ะ',

        # https://www.facebook.com/jarpichit/posts/10150956179953379
        'ฮิ๊,พ๊ก,ธิ๊ฆ์,ใช๊,พ๊ษ๊,สก๊อยซ์,ฯิ๊่,แฒ่ง,ใช๊,ไม๊,ไฎ๊,เร่ย,ธำไฒ,พ๊ก,ฒึง,ถึง,ใช๊,ภ๊ษ๊,วิบัฏิ,ว๊,พ๊ซ์ก,ฒึง,ไม๊,เฆ๊๊,ใจ,'+
        'หร๊,ว่,ภ๊ษ๊,ไธญ,ธิ๊ฆ์,ษืบ,ธอฎ,ม่,ฏั๊ง,ต่,ษฒัย,ภ่ฮ,ฆุณ,ร๊ฒ,คำ,แหง,ฒห๊ษ์า,ร๊ช,ฒัล,ษวญ,ง๊ฒ,แล๊,น่๊,อนุ,รัขษ์,ไว๊,'+
        'ชั่ว,ลุ๊ก,ชั่ว,หล๊น,ฆณษ์าฎ,ไหฯ,ถ๊๊,พ๊ก,มึง,มรั๊ล์ย,รัข,พ๊ษ๊,ไธญ,ก่,ไษ,หัว,ปั๊บ์ยซ์,จ๊ก,ปร๊เธศ,ไธญ,เร่รร,ปั๊บ์ย๊'=>
        'อี,พวก,ที่,ใช้,ภาษา,สก๊อย,นี่,แม่ง,ใช้,ไม่,ได้,เลย,ทำไม,พวก,มึง,ถึง,ใช้,ภาษา,วิบัติ,วะ,พวก,มึง,ไม่,เข้า,ใจ,'+
        'เหรอ,ว่า,ภาษา,ไทย,ที่,สืบ,ทอด,มา,ตั้ง,แต่,สมัย,พ่อ,ขุน,ราม,คำ,แหง,มหา,ราช,มัน,สวย,งาม,และ,น่า,อนุ,รักษ์,ไว้,'+
        'ชั่ว,ลูก,ชั่ว,หลาน,ขนาด,ไหน,ถึง,พวก,มึง,ไม่,รัก,ภาษา,ไทย,ก็,ไส,หัว,ไป,จาก,ประเทศ,ไทย,เลย,ไป',

        #https://www.facebook.com/photo.php?fbid=334536956632235&set=a.331998016886129.77388.276072715811993
        'รุ๊น์ผ,ณิ๊,ม่,ชั๊บ์ย,ฮ์อษ์าหั๊ล์ฯ,๗ิง,น๊,นุ๊ล์ว,แฆ่,ฬอ.,แฏ่ส์ง,รุ๊ผ,เฬอ่น,ม่,รุ๊ล์ว,ว่,จ่,ฮ์อษ์อก,ม๊,เมิธ์่ล,จิ๊.,น่,ธารณ์,ฅนั๊จ,นิ๊'=>
        'รูป,นี้,ไม่,ใช่,อาหาร,จริง,นะ,หนู,แค่,ลอง,แต่ง,รูป,เพื่อน,ไม่,รู้,ว่า,จะ,ออก,มา,เหมือน,จริง,น่า,ทาน,ขนาด,นี้'
        
        ])
	
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
                        raise "count mismatch! #{from_array.size} & #{to_array.size}"
                    end
                else
                    @@db[from] = to
                end
            end
        end
    end
    
    def to_human(str)
        # duplicate variable, so we can modify what's inside
        str = str.clone
        
        # find max from_word in DB
        max_from_word = @@db.keys.map{|s| s.length}.max
        
        i=0
		# iterate through each character in str
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
					i += to.length	# skip to next character
                    matched = true
                    break
                end
            end
			i+=1 if !matched	# go to next character if no word is matched
        end
        str
    end
    
    def to_skoy(str)
        # duplicate variable, so we can modify what's inside
        str = str.clone
        
        # find max from_word in DB
        max_to_word = @@db.values.map{|s| s.length}.max
        
        i=0
	# iterate through each character in str
        while i<str.length
            matched = false
            # try to translate with longest word first
            max_to_word.downto(1).each do |j|
                next if (i+j-1) >= str.length  # do not go into the loop
                to = str[i,j]
                if @@db.has_value?(to)
                    from = @@db.key(to)
                    #puts "==> translate #{to} to #{from}"
                    str[i,j] = from
                    i += from.length	# skip to next character
                    matched = true
                    break
                end
            end
            i+=1 if !matched	# go to next character if no word is matched
        end
        str
    end
end

# main
skoy2human = Skoy2Human.new
input = ''
while input!='exit'
	print 'input word/sentence >'
	input = gets.chomp
	if input!='exit'
		 	# to skoy
		 skoy_word = skoy2human.to_skoy(input)
		 puts "To skoy ===> #{skoy_word}"

		# to human
		human_word = skoy2human.to_human(input)
		puts "To human ===> #{human_word}"
	end
	puts
end

