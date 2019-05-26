#!/usr/bin/env ruby

number_of_times = ARGV[0]

system("rails runner lib/crawl_people.rb -popular #{number_of_times}")
system("rails runner lib/crawl_movie.rb -popular #{number_of_times}")
system("rails runner lib/crawl_tv.rb -popular #{number_of_times}")

system("rails runner lib/crawl_movie.rb -rated #{number_of_times}")
system("rails runner lib/crawl_tv.rb -rated #{number_of_times}")
