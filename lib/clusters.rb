#!/usr/bin/env ruby

class Clusters
	def initialize(client)
		@client = client
	end

	########################################################################################################################
	def listall
	  #login
	  message_title = "Cluster"
	  response = @client.call(:get_cluster_list, message: {emsGuid: "all"})
	  response_hash =  response.to_hash[:get_cluster_list_response][:return]
	  output = AddHashToArray(response_hash[:item])
	  output.each { |key| showminimal("ID", "#{key[:id]}", "#{message_title}", "#{key[:name]}") }
	end
end