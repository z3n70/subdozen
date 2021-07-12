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


END
puts str.yellow
puts
puts "1. Subdomain Scanning"
puts "2. Domain Checker"
puts
print "Enter Number : "
dozen = gets.chomp
puts

if dozen == "1"
    puts  "Example             : "+("google.com").blue
    print "Enter Your Domain   : "
    d = gets.chomp
    print "Enter File Name.txt : "
    name_file = gets.chomp

    puts
    headers = {
        "apikey"     => "Imq3OntknXmbUGuN3IBOtMQCXn0usDq4",
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

    puts "Example subdomain-list.txt"
    puts
    print "Enter List Domain.txt : "
    file = gets.chomp
    print "Enter Save File Name : "
    name_f = "domcheck-#{gets.chomp}.txt"
    puts
    
    data_file = File.open("#{file}", "r").read
    data1 = data_file.split("\n")
    
begin 
    data1.each do |line|
        newuri = URI::HTTP.build({:host => "#{line}"})
        response = HTTParty.get("#{newuri}", timeout: 10)

            case response.code 
                when 200
                    puts "OK           <= #{newuri}".yellow
                    File.open("#{name_f}", "a+"){|file|file.write("#{newuri} => OK\n")}

                when 404
                    puts "Not Found!!    <= #{newuri}".blue
                    # File.open("#{name_f}", "a+"){|file|file.write("#{newuri} => Not Found\n")}

                when 403
                    puts "Forbidden    <= #{newuri}".red
                    File.open("#{name_f}", "a+"){|file|file.write("#{newuri} => Forbidden\n")}

                when 400
                    puts "Bad request  <= #{newuri}".green
                    File.open("#{name_f}", "a+"){|file|file.write("#{newuri} => Bad Request\n")}

                when 500 
                    puts "Server error <= #{newuri}".blue
                    File.open("#{name_f}", "a+"){|file|file.write("#{newuri} => Server Error\n")}

                when 408 
                    puts "Time out     <= #{newuri}".blue
                    File.open("#{name_f}", "a+"){|file|file.write("#{newuri} => Time Out\n")} 
		
                when 302 
                    puts "Redirect     <= #{newuri}".green
                    File.open("#{name_f}", "a+"){|file|file.write("#{newuri} => Redirect\n")}   
                 end
            end
        rescue
        end
	puts
	puts "#{Dir.pwd}/#{name_f}".yellow
	puts 
else
    puts "Input Salah Jang!!".yellow
end
