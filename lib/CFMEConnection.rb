require 'savon'

class CFMEConnection

	def initialize
		@host = nil
		@port = nil
		@url = nil
		@user = nil
		@password = nil
		@client = nil 
		@connected = false
	end

	#######################################################################################################################
	def login (host, user, password)
		begin
			puts "Method: login"
			@host = host
			@user = user
			@password = password

			@url = "https://" << host << "/vmdbws/wsdl" 
			puts "Connecting to #{@url} ..."
			@client = Savon::client(wsdl: @url, ssl_verify_mode: :none, ssl_version: :SSLv3, basic_auth: [user,password], log: :false, pretty_print_xml: :true,
				log_level: :error, raise_errors: :false, log: :false)
			puts "Connected!"
			@connected = true
		rescue => exception
			@connected = false
			puts exception.message
		end
  	end

  	def call (cmd, args)
  		if cmd != nil
  			puts "Calling #{cmd}"
  			if (args != nil)
  				puts "Arguments #{args}"
  				return @client.call(cmd, args)
  			else
  				return @client.call(cmd)
  			end
  		end
  	end

  	########################################################################################################################
	def ems_version
		response = self.call(:version, nil)
  		response_hash =  response.to_hash[:version_response][:return]
		version = response_hash[:item].join(sep=".")
		puts "EMS Version: #{version}"
		return "#{version}"
	end
end
