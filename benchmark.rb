require_relative 'lib/hashmap'
require 'benchmark'

alphanum = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
keys = 1000.times.map{32.times.map{alphanum.sample}.join}
vals = 1000.times.map{32.times.map{alphanum.sample}.join}

map = HashMap.new()
hash = {}
Benchmark.bm(10) do |x|
    x.report("mine adding") { 1000.times.each{|i|map.put(keys[i],vals[i])} }
    x.report("mine getting") { 1000.times.each{|i|puts "WRONG" unless (map.get(keys[i]) == vals[i])} }
    x.report("mine deleting") { 1000.times.each{|i|map.delete(keys[i])} }
    x.report("ruby adding") { 1000.times.each{|i|hash.store(keys[i],vals[i])} }
    x.report("ruby getting") { 1000.times.each{|i|puts "WRONG" unless hash.fetch(keys[i]) == vals[i]} }
    x.report("ruby deleting") { 1000.times.each{|i|hash.delete(keys[i])} }
end
