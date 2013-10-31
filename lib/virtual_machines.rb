#!/usr/bin/env ruby

########################################################################################################################
def virtualmachine_listall(*args)
  login
  message_title = "VM"
  response = @client.request :get_vm_list do
    soap.body = { :hostGuid => "all" }
  end
  response_hash =  response.to_hash[:get_vm_list_response][:return]
  output = AddHashToArray(response_hash[:item])
  output.each { |key| showminimal("GUID", "#{key[:guid]}", "#{message_title}", "#{key[:name]}") }
end

########################################################################################################################
def virtualmachine_gettags(*args)
  if args[0] == "default"
    puts "Error, you must specify ID or name with a value"
  else
    h = splitOpts(args[0])
    vmGuid = h['vmGuid']
    login
    response = @client.request :vm_get_tags do
      soap.body = { :vmGuid => "#{vmGuid}" }
    end
    response_hash =  response.to_hash[:vm_get_tags_response][:return]
    output = AddHashToArray(response_hash[:item])
    output.each { |key| showminimal("Category", "#{key[:category]}", "Tag", "#{key[:tag_display_name]}") }
  end
end
