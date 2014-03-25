require 'savon'
require 'singleton'
require 'httpclient'
HTTPI.adapter = :httpclient

class CFMEConnection
	include Singleton
	
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
			@host = host
			@user = user
			@password = password

			@url = "https://" << host << "/vmdbws/wsdl" 
			puts "# Connecting to #{@url} ..."
			@client = Savon::client(wsdl: @url, ssl_version: :SSLv3, basic_auth: [user,password], log: false, pretty_print_xml: true,
				log_level: :error, raise_errors: false, ssl_verify_mode: :none)

		rescue => exception
			@connected = false
			puts exception.message
		end
  	end

  	def call (cmd, args)
  		if cmd != nil
  			if (args != nil)
  				return @client.call(cmd, args)
  			else
  				return @client.call(cmd)
  			end
  		end
  	end

	def evm_ping
		begin
		    response = self.call(:evm_ping, nil)
		    response_hash =  response.to_hash[:evm_ping_response][:return]
		    if response_hash == true
		    	@connected = true
		    	puts("CFME Engine is up: #{response_hash}") 
		    end
		rescue => exception
		    	@connected = false
		    	puts("CFME Engine is down: #{exception.message}") 
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
