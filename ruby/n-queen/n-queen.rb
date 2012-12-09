#!/usr/bin/env ruby

# Author: ptantiku

def new_table
    table = Array.new(8){ Array.new(8){false} }
end

def print_table(table)
    puts "*" * 30
    table.each{|row|
        row.each{|val|
            print 'Q' if val 
            print '_' if !val
        }
        print "\n"
    }
end

def count_queen(table)
    table.inject(0){|count,row| 
        count+=row.inject(0){|count2,val|
            val ? count2+=1 : count2
        }
    }
end

def check_a_new_queen_at(table,pos)
    row , col = pos/8 , pos%8

=begin 
    #check kings
    ([* row-1 .. row+1 ]
        .product([* col-1 .. col+1 ])-[[row,col]])
            .inject(false){|sum,a| 
                (a[0].between?(0,7) and a[1].between?(0,7))? 
                    sum||=table[a[0]][a[1]] : sum
            }
=end

    #check queen
    ### check same row
    if table[row].inject(false){|sum,val| sum||=val} 
        return true;
    end
    ### check other positions
    [*0...8].inject(false){|sum,r| 
        offset=(r-row).abs; 
        sum||=[col-offset, col, col+offset].inject(false){|sum2,c| 
            c.between?(0,7) ? sum2||=table[r][c] : sum2
        }
    }
end


#main
best_table = nil
best_count = 0
(8*8).times do |queen_first_pos|
    
    row = queen_first_pos/8
    col = queen_first_pos%8

    puts "Put the first queen at position [#{row},#{col}]"
    table = new_table
    table[row][col] = true

    [* 0...8*8].sample(64).each do |new_queen_pos|
        if not check_a_new_queen_at(table,new_queen_pos)
            table[new_queen_pos/8][new_queen_pos%8] = true
        end
    end
    print_table(table)

    if (this_count=count_queen(table)) > best_count
        best_table = table
        best_count = this_count
        puts "!! NEW BEST TABLE !!"
        print_table(table)
    end
end
puts "Best of Best Queens is #{best_count}"
print_table(best_table)

