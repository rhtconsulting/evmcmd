#!/usr/bin/env ruby

class DataStore
	def initialize
		@client = CFMEConnection.instance
	end

	########################################################################################################################
	def listall
	  message_title = "Datastore"
	  response = @client.call( :get_datastore_list, message: { emsGuid: "all" })
	  response_hash =  response.to_hash[:get_datastore_list_response][:return]
	  output = AddHashToArray(response_hash[:item])
	  output.each { |key| showminimal("ID", "#{key[:id]}", "#{message_title}", "#{key[:name]}") }
	end
end