#!/usr/bin/env ruby

require 'httparty'
require 'colorize'
require 'json'
require 'uri'

str = <<END
            ================================

               ┌─┐┬ ┬┌┐ ┌┬┐┌─┐┌─┐┌─┐┌┐┌
               └─┐│ │├┴┐ │││ │┌─┘├┤ │││
               └─┘└─┘└─┘─┴┘└─┘└─┘└─┘┘└┘
                         v 0.2
            ================================
		        @z3n70

END
puts str.yellow
puts
puts "1. Subdomain Scanning"
puts "2. Status Domain Checker"
puts
print "Enter Number : "
dozen = gets.chomp
puts

if dozen == "1"
    puts  "Example             : "+("google.com").colorize(:color => :black, :background => :white)
    print "Enter Your Domain   : "
    d = gets.chomp
    print "Enter File Name.txt : "
    name_file = gets.chomp

    puts
    headers = {
        "apikey"     => "UBGkWBn0wVZxzw94OWEnmGWp0n71cSpo",
    }
    response = HTTParty.get("https://api.securitytrails.com/v1/domain/#{d}/subdomains",
    :headers => headers
    )
    json_data = JSON.parse(response.body)
    for domain in json_data['subdomains']
        out = domain + ".#{d}"
        puts out
        File.open("#{name_file}", "a+"){|dom| dom.write("#{out}\n")}
    end
    puts
    puts "#{Dir.pwd}/#{name_file}".yellow
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
else
    puts "Input Salah Jang!!".yellow
end 
