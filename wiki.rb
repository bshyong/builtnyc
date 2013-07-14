require 'open-uri'
require 'nokogiri'
require 'csv'
require 'cgi'
require 'json'
require 'retryable'

# BASE_URL = 'http://en.wikipedia.org/w/api.php?format=json&action=query&prop=revisions&rvprop=content&titles='
BASE_URL = 'http://en.wikipedia.org/wiki/'

while($input_filename.nil?)
  puts "Enter input filename (should be a CSV)"
  $input_filename = gets.chomp!
end

while($filename.nil?)
  puts "Enter a filename (output will be stored as a CSV)"
  $filename = gets.chomp!
end

output = File.new("#{$filename}.csv", "a+")
count = 0

# callbacks for Retryable
def then_cb
  Proc.new do |exception, handler, attempts, retries, times|
    puts "#{exception.class}: '#{exception.message}' - #{attempts} attempts, #{retries} out of #{times} retries left."
  end
end

def finally_cb
  Proc.new do |exception, handler|
    puts "#{exception.class} raised too many times. First attempt at #{handler[:start]} and final attempt at #{Time.now}"
  end
end

def always_cb
  Proc.new do |handler, attempts|
    puts "total time for #{attempts} attempts: #{Time.now - handler[:start]}"
  end
end

# parse HTML from input file
doc = Nokogiri::HTML(File.open($input_filename).read)

# fetch all buildings
building_rows = doc.css('.vcard')

# get attributes and write to CSV file
building_rows.each do |br|
  name = br.css('td')[0].content
  puts "writing #{name}"
  address = br.css('td.adr span.label')[0].content
  latitude = br.css('td.adr span.latitude')[0].content
  longitude = br.css('td.adr span.longitude')[0].content
  city = br.css('td.locality')[0].content
  link = "http://en.wikipedia.org" + br.css('td a')[0].attr('href')
  output.puts(CSV.generate_line([name, address, latitude, longitude, city, link]))
  puts "done \n"
end

# def try_search(row, output)
#   Retryable.retryable :on => [Timeout::Error, Errno::ECONNRESET], :times => 10, :then => then_cb, :finally => finally_cb, :always => always_cb do |handler|
#     handler[:start] ||= Time.now
#     doc = open("http://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=#{CGI::escape(row[0])}&format=json").read
#     title = JSON.parse(doc)["query"]["search"][0]["title"] rescue nil
#     next puts "> no results" if title.nil?
#     puts "> #{url = BASE_URL + CGI::escape(title.gsub(' ', '_'))}"
#     doc = Nokogiri::HTML(open(url))
#     description = doc.css('#mw-content-text').css('p')[0].content.split('.')[0,2].join('. ') rescue nil
#     next puts "> no description" if description.nil?
#     output.puts(CSV.generate_line([row[0], "", title, description]))
#     puts "> done"
#   end
# end

# CSV.foreach($input_filename) do |row|
#   begin
#     puts "#{count+=1} _ processing #{row[0]}"
#     puts url = BASE_URL + row[0].gsub(' ', '_')
#     doc = Nokogiri::HTML(open(url))
#     description = doc.css('#mw-content-text').css('p')[0].content.split('.')[0,2].join('. ')
#     output.puts(CSV.generate_line([row[0], description]))
#     puts "done \n"
#   rescue => e
#     case e.message
#     when /404/
#       puts "page not found...trying search instead"
#       try_search(row, output)
#     else
#       puts "something went wrong!  skipping"
#       puts $!.message
#     end
#   end
# end
