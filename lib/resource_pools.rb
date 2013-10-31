#!/usr/bin/env ruby

def resourcepool_listall(*args)
  login
  message_title = "Resource Pool"
  response = @client.request :get_resource_pool_list do
    soap.body = { :emsGuid => "all" }
  end
  response_hash =  response.to_hash[:get_resource_pool_list_response][:return]
  output = AddHashToArray(response_hash[:item])
  output.each { |key| showminimal("ID", "#{key[:id]}", "#{message_title}", "#{key[:name]}") }
end