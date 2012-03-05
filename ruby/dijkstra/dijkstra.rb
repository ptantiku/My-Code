#!/usr/bin/env ruby
# written by ptantiku

#create graph 
#(from http://optlab-server.sce.carleton.ca/POAnimations2007/DijkstrasAlgo.html)
#           O   A   B   C   D   E   F   T
$graph = [[ 0,  2,  5,  4, -1, -1, -1, -1 ], # from O
         [  2,  0,  2, -1,  7, -1, 12, -1 ], # from A
         [  5,  2,  0,  1,  4,  3, -1, -1 ], # from B
         [  4, -1,  1,  0, -1,  4, -1, -1 ], # from C
         [ -1,  7,  4, -1,  0,  1, -1,  5 ], # from D
         [ -1, -1,  3,  4,  1,  0, -1,  7 ], # from E
         [ -1, 12, -1, -1, -1, -1,  0,  3 ], # from F
         [ -1, -1, -1, -1,  5,  7,  3,  0 ], # from T
        ]

nodeName = ['O','A','B','C','D','E','F','T']
usedNode = [0]              # 0 == Node 'O' the origin
distanceToNodes = Array.new(nodeName.size, 9999) #default all distance to 9999
distanceToNodes[0] = 0      #set distance to node 'O' from 'O' is 0
unUsedNode = (1...nodeName.size).to_a

def findAdjacentNodeSet(fromNodeSet, otherNodeSet)
    resultNodeSet = []
    fromNodeSet.product(otherNodeSet).each{|fromNode,endNode|
            resultNodeSet << endNode unless $graph[fromNode][endNode]==-1 
    }
    return resultNodeSet.uniq
end

while unUsedNode.size>0 do
    #print used node
    puts "used nodes = #{usedNode.collect{|n| nodeName[n]}}"
    puts "Node distances = #{distanceToNodes.join(',')}"
    
    #find adjacent node
    adjacentNodes = findAdjacentNodeSet(usedNode,unUsedNode)
    puts "adjacent nodes = #{adjacentNodes.collect{|n| nodeName[n]}}"
    
    #finding closest node
    selectedNode = -1  #just default
    selectedNodeLength = 9999
    adjacentNodes.each{|endNode|
        endNode_ShortestLength = 9999
        usedNode.each{|fromNode|
            if $graph[fromNode][endNode]!=-1    #if possible to go to that node
                distance = distanceToNodes[fromNode] + $graph[fromNode][endNode]
                if distance < endNode_ShortestLength
                    endNode_ShortestLength = distance
                end
                puts "New distance from #{fromNode} --> #{endNode} = #{distance}"
            end
        }
        puts "shortest distance = #{endNode_ShortestLength}"
        #now getting the best (shortest distance to 'endNode')
        #compare with other 'endNodes' to select only one for each iteration
        if endNode_ShortestLength<selectedNodeLength
            selectedNode, selectedNodeLength = endNode, endNode_ShortestLength
        end
    }
    
    #process the new node
    if selectedNode != -1
        distanceToNodes[selectedNode] = selectedNodeLength
        usedNode << unUsedNode.delete(selectedNode) #move from unused to used
    end
end

puts "----------Final Result-----------"
puts "Nodes are #{usedNode.collect{|node| nodeName[node]}}"
puts "distance to the nodes are as following:"
usedNode.each{|node|
    puts "#{node} : #{nodeName[node]} => #{distanceToNodes[node]}"
}
