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

def managementsystem_tags(*args)
  @get_vars = args[0]
  @get_vars.each { |a| p a }
  @get_vars.keys.each { |name| instance_variable_set "@" + name.to_s, get_vars[name] }
  #get_vars.each { |(a,b)| puts "#{a} #{b}" }
  login
  response = @client.request :ems_get_tags do
    soap.body = { :emsGuid => "02f0f85e-3b54-11e3-bce6-005056b367d4" }
  end
  response_hash =  response.to_hash[:ems_get_tags_response][:return]
  response_hash[:item].each { |key| showminimal("Category", "#{key[:category_display_name]}", "Tag", "#{key[:tag_display_name]}") }
end