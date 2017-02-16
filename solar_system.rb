# Data for populating planet objects
planet_info = [
  {name: "Mercury", mass:	0.33,	diameter: 4879, moons:	0, distance_from_the_sun: 57.9, rings: 0, length_of_planet_year: 22_823_370},
  {name: "Venus", mass: 4.87, diameter:	12104, moons: 0, distance_from_the_sun: 108.2, rings: 0, length_of_planet_year: 9_339_106},
  {name: "Earth", mass:	5.97, diameter: 12756, moons: 1, distance_from_the_sun: 149.6, rings: 0, length_of_planet_year: 31_629_460},
  {name: "Mars", mass:	0.642, diameter: 6792,	moons:	2, distance_from_the_sun: 227.9, rings: 0, length_of_planet_year: 59_722_203},
  {name: "Jupiter", mass:	1898, diameter:	142984,	moons:	67, distance_from_the_sun: 778.6, rings: 4, length_of_planet_year: 376_882_324},
  {name: "Saturn", mass:	568, diameter:	120536,	moons: 62, distance_from_the_sun: 1433.5, rings: 12, length_of_planet_year: 925_693_159},
  {name: "Uranus", mass:	86.8, diameter:	51118,	moons: 27, distance_from_the_sun: 2872.5, rings: 13, length_of_planet_year: 2_697_049_440},
  {name: "Neptune", mass:	102, diameter:	49528,	moons: 14, distance_from_the_sun: 4495.1, rings: 6, length_of_planet_year: 5_425_906_080},
  {name: "Pluto", mass:	0.0146,	diameter: 2370,	moons: 5, distance_from_the_sun: 5906.4, rings: 0, length_of_planet_year: 7_888_669_165}
]

units = {
  mass: "10^24 kg",
  diameter: "km",
  moons: "moon(s)",
  distance_from_the_sun: "10^6 km",
  rings: "rings",
  length_of_planet_year: "seconds"
}

class Planet
  attr_accessor :rings, :diameter, :mass, :moons, :name, :distance_from_the_sun, :length_of_planet_year

  def initialize params={}
    @name = params[:name]
    @distance_from_the_sun = params[:distance_from_the_sun]
    @length_of_planet_year = params[:length_of_planet_year]
    @rings = params[:rings]
    @diameter = params[:diameter]
    @mass = params[:mass]
    @moons = params[:moons]
  end

  def distance_from other_planet
    (@distance_from_the_sun - other_planet.distance_from_the_sun).abs
  end

end

class SolarSystem
  attr_accessor :name, :planets, :age_in_seconds

  def initialize params={}
    @name = params[:name]
    @planets = params[:planets]
    @age_in_seconds = params[:age_in_seconds]
  end

  def add_planet planet
    @planets << planet
  end

  def add_planets planets
    @planets.concat(planets)
  end

  def print_planets
    puts "Here are all the planets in #{@name}:"
    @planets.each {|planet| puts "  #{planet.name}"}
  end

end

# Calculates the number of a planet's years since solar system formation
def planet_year solar_system, planet
  solar_system.age_in_seconds / planet.length_of_planet_year
end

# Displays numbers with commas
def format_number number
  number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end

# Method to transform method names to English titles
def titlize phrase
  words = phrase.to_s.split("_")
  words.each do |word|
    word.capitalize! unless ['a','the','of','to','from'].include?(word)
  end
  words.join(" ")
end

# Set up planets array
planets = []
(planet_info.length).times do |index|
  planets << Planet.new(planet_info[index])
end

# Set up solar system
sol = SolarSystem.new({
    name: "Sol",
    planets: planets,
    age_in_seconds: 4_600_000_000_000*365*24*60*60
  })


# Displays facts about a given planet
puts "Which planet would you like to learn about?"

def get_planet array
  # Print out list of planets with 'Exit' option at the end
  array.each_with_index do |planet, index|
    puts "#{index + 1}. #{planet.name}"
  end
  puts "#{array.length + 1}. Exit"
  puts

  # Validate that user input corresponds to a number option from the list
  input = gets.chomp.to_i
  until (1..(array.length + 1)).to_a.include? input
    print "Please input a number between 1 and #{array.length + 1} > "
    input = gets.chomp.to_i
  end
  exit if input == array.length + 1
  array[input - 1]
end

first_planet = get_planet planets

# display planet facts from object
puts "FUN FACTS ABOUT #{first_planet.name.upcase}:"
units.each do |fact, unit|
  print "#{titlize(fact)}: "
  puts "#{first_planet.send(fact.to_sym)} #{unit}".rjust(40 - titlize(fact).length)
end

# display planet years since solar system formation
puts "\nIt has been #{format_number(planet_year(sol, first_planet))} \
#{first_planet.name} years since the formation of #{sol.name}."

puts "\nOk, choose another planet to calculate the distance between the planets!"
second_planet = get_planet planets

puts "#{first_planet.name} is #{first_planet.distance_from(second_planet).round(2)} \
#{units[:distance_from_the_sun]} from #{second_planet.name}."

# Add new planets to solar system
print "\nDo you want to add some new planets to the solar system? > "
input = gets.chomp
until input == 'yes' || input == 'no'
  print "Please type 'yes' or 'no' > "
  input = gets.chomp
end

if input == 'no'
  puts "OK BYE"
  exit
end

puts "Ok, type up some planet names! (type 'exit' to stop)"
user_planet = ""

until user_planet == 'exit'
  print "Planet Name: "
  user_planet = gets.chomp
  sol.add_planet Planet.new({name: user_planet}) unless user_planet == 'exit'
end

puts
puts "BREAKING NEWS! #{sol.name.upcase} HAS NEW PLANETS."
sol.print_planets
