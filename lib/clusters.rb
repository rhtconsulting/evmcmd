#!/usr/bin/env ruby

def cluster_listall
  login
  message_title = "Cluster"
  response = @client.request :get_cluster_list do
    soap.body = { :emsGuid => "all" }
  end
  response_hash =  response.to_hash[:get_cluster_list_response][:return]
  response_hash[:item].each { |key| showminimal("ID", "#{key[:id]}", "#{message_title}", "#{key[:name]}") }
end
