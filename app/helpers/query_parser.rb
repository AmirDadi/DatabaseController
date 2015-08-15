require 'java'
require './JSQL Parser.jar'
require './jsqlparser-0.7.0.jar'

obj = Java::Query.new(ARGV[0])
obj.getTable.each do |table|
	puts table + ","
end
# stringreader = Java::StringReader.new


