#!/usr/bin/env ruby

def resourcepool_listall
  login
  message_title = "Resource Pool"
  response = @client.request :get_resource_pool_list do
    soap.body = { :emsGuid => "all" }
  end
  response_hash =  response.to_hash[:get_resource_pool_list_response][:return]
  response_hash[:item].each { |key| showminimal("ID", "#{key[:id].inspect}", "#{message_title}", "#{key[:name].inspect}") }
end