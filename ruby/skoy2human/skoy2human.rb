#!/usr/bin/env ruby
# encoding: utf-8

# Skoy2Human for translating between Skoy language and human language
# author anidear

# original author NarZe
# original source code in Javascript at https://github.com/NarzE/toSkoy/blob/master/toskoy.js

class Skoy2Human
    @@db = Hash.new
    
    def initialize()
        learn(Hash[
            'ู'=>'ุ๊',
            'ย'=>'ญ',
            'ะ'=>'๊',
            'ด'=>'ฎ',
            'ต'=>'ฏ',
            'ข'=>'ฆ',
            'อ'=>'ฮ',
            'ท'=>'ธ',
            'ี'=>'ิ๊',
            '้'=>'๊',
            'น'=>'ณ',
            'พ'=>'ภ',
            'ภ'=>'พ',
            'า'=>'๊',
            'ฉ'=>'ช๋',
            'หนุ'=>'นุ๊วซ์',
            'อยาก'=>'ญั๊ข',
            'คะ'=>'ขร๊',
            'ค่ะ'=>'ฆร่',
            'ัน'=>'ัล',
            'วก'=>'๊ก',
            'พวก,คุณ,จะ,ว่า,อะ,ไร,ก็,เชิญ,เลย,นะ,พวก,เรา,ไม่,สน,หรอก' => 
            'พ๊ก,คุ๊ล,จ่,ว่,อ่,รั๊ย,ก่,เซิฬ,เร่ย,น๊,พ๊ก,เลา,ไม๊,ส่น,หร่อก',
            'มี,นิ,ทาน,มา,เล่า,ให้,พี่,ฟัง,คะ,นิ,ทาน,เรื่อง,นี้,สอน,ให้,รู้,ว่า,ชาว,นา,กับ,ทะ,เล,ที่,หก' => #skip "หนู"
            'มริ๊,ณิ๊,ธาง์ร,ม่,เฬอ่า,หั๊ล์ย,พริ๊ต์,ฟรั๊ก์ง,ค๊,ณิ๊,ธาถ์ฯ,เฬอื่บ์ลง,ณิ๊,ศั๊ฎ์,ญหั๊ล์,รุ๊ง์ว,ว่,ชั๊ส์ว,ณฆ์า,กั๊ผ,ฑะ,เฬ,ธิ๊ฆ์,หค์ก', #skip 'ุ๊ซ์ว
            'กาล,ครั้ง,หนึง,ชาว,นา,กำ,ลัง,หา,ปลา,อยู่,ใน,แต่,ว่า,หา,ยัง,ไง,ก็,ไม่,เจอ,ชาว,นา,ก็,เลย,ไป' =>
            'กั๊รฬว์ะ,ฅั๊ฐ์งหสุ์,ณึ่,ชั๊ย์ว,ณฆ์า,กั๊,ร์ฬ,ห๊ษ์า,ปธ์ฬา,ยุ๊ว์ซ,นั๊บ์ย,ต่,ว๊พ์,ห๊ษ์า,ญั๊ล์ง,งั๊.,กํ,มรั๊ล์ย,เ๗อ,ชั๊ซ์ว,ณษ์า,ก่,เร่รร,ปั๊บ์ย'        
            ])
            # https://www.facebook.com/sowhateiei/posts/333737343378863
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
    
    def to_skoy(str)
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
                    puts "==> translate #{from} to #{to}"
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
    
    def to_human(str)
        #duplicate variable, so we can what's inside
        str = str.clone
        
        # find max from_word in DB
        max_to_word = @@db.values.map{|s| s.length}.max
        
        i=0
        while i<str.length
            matched = false
            # try to translate with longest word first
            max_to_word.downto(1).each do |j|
                next if (i+j-1) >= str.length  # do not go into the loop
                to = str[i,j]
                if @@db.has_value?(to)
                    from = @@db.key(to)
                    puts "==> translate #{to} to #{from}"
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
        puts skoy_word
        
        # to human
        human_word = skoy2human.to_human(input)
        puts human_word
    end
end

