#!/usr/bin/env ruby
require 'readline'
require 'savon'

Savon.configure do |config|
  config.log = false
  config.pretty_print_xml = true
  config.log_level = :info
  config.raise_errors = false
  HTTPI.log = false
end

def login
  url = "https://10.15.69.175/vmdbws/wsdl"
  user = "admin"
  password = 'smartvm'
  # Set up Savon client
  @client = Savon::Client.new do |wsdl, http|
    wsdl.document = "#{url}"
    http.auth.basic "#{user}", "#{password}"
    http.auth.ssl.verify_mode = :none
  end
end

def quit
  send(exit)
end

def exit
  puts "Goodbye!"
  Process.exit!(true)
end

def get_allmanagementsystems
  login
  message_title = "Management System"
  # Query CFME web-service
  response = @client.request "GetEmsList"

  # Convert response to hash
  response_hash =  response.to_hash[:get_ems_list_response][:return]
  #puts "CFME web-service returned: #{response_hash.inspect}"

  # Loop through each management system in the array and log the name and guid
  response_hash[:item].each { |key| puts "#{message_title}: #{key[:name].inspect} GUID: #{key[:guid].inspect}" }
end

def get_allhosts
  login
  message_title = "host"
  # Query CFME web-service
  response = @client.request :get_host_list do
    soap.body = { :emsGuid => "all" }
  end
  # Convert response to hash
  response_hash =  response.to_hash[:get_host_list_response][:return]
  #puts "CFME web-service returned: #{response_hash.inspect}"

  # Loop through each management system in the array and log the name and guid
  response_hash[:item].each { |key| puts "#{message_title}: #{key[:name].inspect} GUID: #{key[:guid].inspect}" }
end

def get_allvms
  login

  message_title = "VM"

  # Query CFME web-service
  response = @client.request :get_vm_list do
    soap.body = { :hostGuid => "all" }
  end
  # Convert response to hash
  response_hash =  response.to_hash[:get_vm_list_response][:return]
  #puts "CFME web-service returned: #{response_hash.inspect}"

  # Loop through each management system in the array and log the name and guid
  response_hash[:item].each { |key| puts "#{message_title}: #{key[:name].inspect} GUID: #{key[:guid].inspect}" }
end

def get_allclusters
  login

  message_title = "Cluster"

  # Query CFME web-service
  response = @client.request :get_cluster_list do
    soap.body = { :emsGuid => "all" }
  end
  # Convert response to hash
  response_hash =  response.to_hash[:get_cluster_list_response][:return]
  #puts "CFME web-service returned: #{response_hash.inspect}"

  # Loop through each management system in the array and log the name and guid
  response_hash[:item].each { |key| puts "#{message_title}: #{key[:name].inspect} ID: #{key[:id].inspect}" }
end

def get_allresourcepools
  login

  message_title = "Resource Pool"

  # Query CFME web-service
  response = @client.request :get_resource_pool_list do
    soap.body = { :emsGuid => "all" }
  end
  # Convert response to hash
  response_hash =  response.to_hash[:get_resource_pool_list_response][:return]
  #puts "CFME web-service returned: #{response_hash.inspect}"

  # Loop through each management system in the array and log the name and guid
  response_hash[:item].each { |key| puts "#{message_title}: #{key[:name].inspect} ID: #{key[:id].inspect}" }
end

def help
puts "#  This is a work in progress, only have commands to allow to query cloudforms without options being passed at this time
#  You are able to tab complete each command if needed

\t Commands that can currently be run:
\t\t get_allmanagementsystems
\t\t get_allhosts
\t\t get_allvms
\t\t get_allclusters
\t\t get_allresourcepools
\t\t get_alldatastores
\t\t help
\t\t exit
"
end

def get_alldatastores
  login

  message_title = "Datastore"

  # Query CFME web-service
  response = @client.request :get_datastore_list do
    soap.body = { :emsGuid => "all" }
  end
  # Convert response to hash
  response_hash =  response.to_hash[:get_datastore_list_response][:return]
  #puts "CFME web-service returned: #{response_hash.inspect}"

  # Loop through each management system in the array and log the name and guid
  response_hash[:item].each { |key| puts "#{message_title}: #{key[:name].inspect} ID: #{key[:id].inspect}" }
end

help

LIST = [
  'get_allmanagementsystems',
  'get_allhosts',
  'get_allvms',
  'get_allclusters',
  'get_allresourcepools',
  'get_alldatastores',
  'help',
  'exit'
].sort

comp = proc { |s| LIST.grep(/^#{Regexp.escape(s)}/) }

Readline.completion_append_character = ""
Readline.completion_proc = comp

while line = Readline.readline('> ', true)
  send(line)
end
