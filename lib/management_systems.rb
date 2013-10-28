#!/usr/bin/env ruby

def managementsystem_listall
  login
  message_title = "Management System"
  response = @client.request "GetEmsList"
  response_hash =  response.to_hash[:get_ems_list_response][:return]
  response_hash[:item].each { |key| puts "GUID: #{key[:guid]}\t #{message_title}: #{key[:name]}" }
  guid_output = Array.new
  response_hash[:item].each { |key| guid_output.push("#{key[:guid]}") }
  puts "#{guid_output}"
end
