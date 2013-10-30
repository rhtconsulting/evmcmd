#!/usr/bin/env ruby

def managementsystem_listall(*args)
  login
  message_title = "Management System"
  response = @client.request "GetEmsList"
  response_hash =  response.to_hash[:get_ems_list_response][:return]
  response_hash[:item].each { |key| puts "GUID: #{key[:guid]}\t #{message_title}: #{key[:name]}" }
  guid_output = Array.new
  response_hash[:item].each { |key| guid_output.push("#{key[:guid]}") }
  puts "#{guid_output}"
end

def managementsystem_gettags(*args)
  if args[0] == "default"
    puts "Error, you must specify emsGuid or name with a value"
  else
    h = splitOpts(args[0])
    puts h.inspect
    emsGuid = h['emsGuid']
    login
    response = @client.request :ems_get_tags do
      soap.body = { :emsGuid => "#{emsGuid}" }
    end
    response_hash =  response.to_hash[:ems_get_tags_response][:return]
    output = AddHashToArray(response_hash[:item])
    output.each { |key| showminimal("Category", "#{key[:category_display_name]}", "Tag", "#{key[:tag_display_name]}") }
  end
end