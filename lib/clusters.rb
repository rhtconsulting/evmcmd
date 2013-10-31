#!/usr/bin/env ruby

########################################################################################################################
def cluster_listall(*args)
  login
  message_title = "Cluster"
  response = @client.request :get_cluster_list do
    soap.body = { :emsGuid => "all" }
  end
  response_hash =  response.to_hash[:get_cluster_list_response][:return]
  output = AddHashToArray(response_hash[:item])
  output.each { |key| showminimal("ID", "#{key[:id]}", "#{message_title}", "#{key[:name]}") }
end
