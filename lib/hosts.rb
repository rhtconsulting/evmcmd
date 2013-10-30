#!/usr/bin/env ruby

#####################################################################################
def host_listall(*args)
  login
  message_title = "Host"
  response = @client.request :get_host_list do
    soap.body = { :emsGuid => "all" }
  end
  response_hash =  response.to_hash[:get_host_list_response][:return]
  response_hash[:item].each { |key| showminimal("GUID", "#{key[:guid]}", "#{message_title}", "#{key[:name]}") }
end

#####################################################################################
def host_getvms(*args)
  login
  message_title = "Host"
  response = @client.request :evm_get_vms do
    soap.body = { :hostGuid => "294a86b4-3b54-11e3-97a2-005056b367d4" }
  end
  response_hash =  response.object[:evm_get_vms_response][:return]

  #response_hash[:item].each { |key| showminimal("ID", "#{key[:id]}") }
end


def host_gettags(*args)
  if args[0] == "default"
    puts "Error, you must specify ID or name with a value"
  else
    h = splitOpts(args[0])
    puts h.inspect
    hostGuid = h['hostGuid']
    login
    response = @client.request :host_get_tags do
      soap.body = { :hostGuid => "#{hostGuid}" }
    end
    response_hash =  response.to_hash[:host_get_tags_response][:return]
    output = AddHashToArray(response_hash[:item])
    output.each { |key| showminimal("Category", "#{key[:category_display_name]}", "Tag", "#{key[:tag_display_name]}") }
  end
end