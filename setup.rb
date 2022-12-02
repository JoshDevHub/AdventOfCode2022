# frozen_string_literal: true

require "rest-client"

# checks for command line arg for day name
day_num = ARGV[0]
missing_arg_msg = "Please enter a valid day number as a command line arg"
raise ArgumentError, missing_arg_msg unless ("1".."25").include?(day_num)

# checks that day doesn't already exist
dir_name = "day#{day_num.rjust(2, '0')}"
day_exists_msg = "The directory for this day already exists"
raise ArgumentError, day_exists_msg if Dir.exist?(dir_name)

# create folders/files for new day
Dir.mkdir(dir_name)
Dir.chdir(dir_name)

FileUtils.touch("puzzle.rb")
FileUtils.touch("test.txt")

# GET puzzle input for day from advent of code & write to txt file
url = "https://adventofcode.com/2022/day/#{day_num}/input"
response =
  RestClient.get(
    url,
    { cookies: { session: ENV.fetch("AOC_SESSION_COOKIE") } }
  )

File.open("input.txt", "w") { |f| f.puts(response) }
