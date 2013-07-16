require 'open-uri'
require 'nokogiri'
require 'csv'
require 'retryable'

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

CSV.foreach($input_filename) do |row|
  begin
    puts "#{count+=1} _ processing #{row[0]}"
    puts url = row.last
    doc = Nokogiri::HTML(open(url))
    image_url = doc.css('a.image img')[0]["src"] rescue nil
    year_built = doc.css('table.infobox th:contains("Built:")').first.next_element.text rescue nil
    # architect =
    # developer =
    architectural_style = doc.css('table.infobox th:contains("Architectural")').first.next_element.text rescue nil
    governing_body = doc.css('table.infobox th:contains("Governing body:")').first.next_element.text rescue nil
    categories = doc.css('#mw-normal-catlinks li a').map{|c| c.text} rescue nil
    nrhp_reference = doc.css('table.infobox th:contains("NRHP")').first.next_element.text rescue nil
    address = doc.css('table.infobox th:contains("Location:")').first.next_element.text rescue nil
    summary = ""
    doc.css('#mw-content-text').children.each do |x|
      summary += x.content if x.name == "p"
      break if x.name == "h2"
    end

    output.puts(CSV.generate_line([row[0], image_url, year_built, summary, architectural_style, governing_body, categories, nrhp_reference, address]))
    puts "done \n"
  rescue => e
    # case e.message
    # when /404/
    #   puts "page not found...trying search instead"
    #   try_search(row, output)
    # else
      puts "something went wrong!  skipping"
      puts $!.message
      output.puts(CSV.generate_line([]))
    # end
  end
end