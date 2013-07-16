# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name(role, :without_protection => true)
  puts 'role: ' << role
end
puts 'DEFAULT USERS'
user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
puts 'user: ' << user.name
user.add_role :admin

puts 'seed data'
data = CSV.read("#{Rails.root}/lib/seed_data/clean_seed_data.csv", :encoding => "windows-1251:utf-8")
# shift to get rid of headers
data.shift
count = 0
data.each do |row|
  puts "processing row #{count += 1}"
  puts "creating place #{row[0]}"
  Place.attr_accessible :name, :location, :latitude, :longitude, :locality, :link, :summary, :year_built, :image_url, :arch_style, :gov_body, :nrhp_ref
  place = Place.find_or_create_by_name(:name => row[0].chomp,
                                       :location => row[1],
                                       :latitude => row[2],
                                       :longitude => row[3],
                                       :locality => row[4],
                                       :link => row[5],
                                       :summary => row[6],
                                       :year_built => row[7],
                                       :image_url => ("http:" + row[8] rescue nil),
                                       :arch_style => row[9],
                                       :gov_body => row[10],
                                       :nrhp_ref => row[12])

  categories = eval(row[11]) rescue nil
  next puts "skipping; no categories" if categories.blank?
  categories.each do |c|
    puts "adding category #{c}"
    place.categories << Category.find_or_create_by_name(:name => c.strip)
  end
  puts "done\n\n"
end
