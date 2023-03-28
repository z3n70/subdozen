#!/usr/bin/env ruby

require 'httparty'
require 'colorize'
require 'json'
require 'open-uri'
require 'uri'

loop do
str = <<END
            ================================

               ┌─┐┬ ┬┌┐ ┌┬┐┌─┐┌─┐┌─┐┌┐┌
               └─┐│ │├┴┐ │││ │┌─┘├┤ │││
               └─┘└─┘└─┘─┴┘└─┘└─┘└─┘┘└┘
                         v 1.1
            ================================
		        @z3n70

END
puts str.yellow
puts
puts "1. Subdomain Scanning"
puts "2. Status Domain Checker"
puts "3. Exit"
puts
print "Enter Number : "
dozen = gets.chomp
puts

if dozen == "1"
    print "Inputkan Target : "
    target = gets.chomp

    puts
    url = "https://crt.sh/?q=%25.#{target}"
    curl_out = URI.open(url).read
    domain_list = curl_out.scan(/<TD>(.*?)<\/TD>/).flatten.select {|x| x.match?(/^[\w\d.-]+\.[a-z]{2,}$/)}
     File.write("subdomain-#{target}", domain_list.uniq.join("\n"))
    puts File.read("subdomain-#{target}")
    puts
    puts "File Saved => #{Dir.pwd}/subdomain-#{target}".yellow
    puts

elsif dozen == "2"
begin
    puts "Example subdomain-list.txt".colorize(:color => :black, :background => :white)
    puts
    print "Enter List Domain.txt : "
    file = gets.chomp
    print "Enter Save File Name : "
    name_f = "domcheck-#{gets.chomp}.txt"
    puts

    data_file = File.open("#{file}", "r").read

#debugger
    data1 = data_file.split("\n")

    data1.each do |line|
        newuri = URI::HTTP.build({:host => "#{line}"})
    begin
        response = HTTParty.get(newuri, timeout: 5, :verify => false)
        # puts newuri

        if response.code == 200
            puts "#{newuri} => OK".yellow
            File.open("#{name_f}","a+"){|file|file.write("#{newuri} => OK\n")}

        elsif response.code == 404
            puts "#{newuri} => Not Found!!".red
            File.open("#{name_f}","a+"){|file|file.write("#{newuri} => Not Found\n")}

        elsif response.code == 403
            puts "#{newuri} => Forbidden".blue
            File.open("#{name_f}","a+"){|file|file.write("#{newuri} => Forbidden\n")}

        elsif response.code == 500
            puts "#{newuri} => Server Error".red
            File.open("#{name_f}","a+"){|file|file.write("#{newuri} => Server Error\n")}

        elsif response.code == 400
            puts "#{newuri} => Bad Request".blue
            File.open("#{name_f}","a+"){|file|file.write("#{newuri} => Bad Request\n")}

        elsif response.code == 302
            puts "#{newuri} => Redirect".blue
            File.open("#{name_f}","a+"){|file|file.write("#{newuri} => Redirect\n")}

        elsif response.code == 408
            puts "#{newuri} => Time Out".red
            File.open("#{name_f}","a+"){|file|file.write("#{newuri} => Time Out\n")}

        elsif response.code == 521
            puts "#{newuri} => Server Down".red
            File.open("#{name_f}","a+"){|file|file.write("#{newuri} => Server Down\n")}

        else
            puts "#{newuri} => Error".red
            File.open("#{name_f}","a+"){|file|file.write("#{newuri} => Error\n")}
        end
    rescue
    rescue OpenSSL::SSL::SSLError
        puts "SSL Error..."
    rescue Errno::ECONNREFUSED
        puts "Connection Refused!"
	end
end

	puts
	puts "File Saved => #{Dir.pwd}/#{name_f}".yellow
    puts
rescue Interrupt
    puts "Leaving the program...".red
end

    elsif dozen == "3"
    exit 1

    else
        puts "Wrong Input!".yellow
    end
end
