#!/usr/bin/env ruby

def datastore_listall
  login
  message_title = "Datastore"
  response = @client.request :get_datastore_list do
    soap.body = { :emsGuid => "all" }
  end
  response_hash =  response.to_hash[:get_datastore_list_response][:return]
  response_hash[:item].each { |key| showminimal("ID", "#{key[:id]}", "#{message_title}", "#{key[:name]}") }
end