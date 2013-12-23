#!/usr/bin/env ruby

class ResourcePool
	def initialize
		@client = CFMEConnection.instance
	end

	def listall
	  message_title = "Resource Pool"
	  response = @client.call( :get_resource_pool_list, message:{ emsGuid: "all" } )
	  response_hash =  response.to_hash[:get_resource_pool_list_response][:return]
	  output = AddHashToArray(response_hash[:item])
	  output.each { |key| showminimal("ID", "#{key[:id]}", "#{message_title}", "#{key[:name]}") }
	end
end