#!/usr/bin/env ruby

def virtualmachine_listall
  login
  message_title = "VM"
  response = @client.request :get_vm_list do
    soap.body = { :hostGuid => "all" }
  end
  response_hash =  response.to_hash[:get_vm_list_response][:return]
  response_hash[:item].each { |key| showminimal("GUID", "#{key[:guid]}", "#{message_title}", "#{key[:name]}") }
end