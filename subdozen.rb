require 'httparty'
require 'colorize'
require 'json'
str = <<END
                  ================================

                     ┌─┐┬ ┬┌┐ ┌┬┐┌─┐┌─┐┌─┐┌┐┌
                     └─┐│ │├┴┐ │││ │┌─┘├┤ │││
                     └─┘└─┘└─┘─┴┘└─┘└─┘└─┘┘└┘
                  
                  ================================
END
puts str.yellow
puts

print "Enter Your Domain : "
d = gets.chomp
headers = {
     "apikey"     => "oSc5Ud5Vw9pQM2no5eoObwmkMLsuOyyX",
}
response = HTTParty.get("https://api.securitytrails.com/v1/domain/#{d}/subdomains",
 :headers => headers
 )

json_data = JSON.parse(response.body)

for domain in json_data['subdomains']
   puts domain + ".#{d}"
end