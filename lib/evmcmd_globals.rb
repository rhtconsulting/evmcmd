#!/usr/bin/env ruby

load "#{$INSTALL_PATH}/lib/select.rb"
load "#{$INSTALL_PATH}/lib/management_systems.rb"
load "#{$INSTALL_PATH}/lib/hosts.rb"
load "#{$INSTALL_PATH}/lib/resource_pools.rb"
load "#{$INSTALL_PATH}/lib/clusters.rb"
load "#{$INSTALL_PATH}/lib/datastores.rb"
load "#{$INSTALL_PATH}/lib/virtual_machines.rb"

# Revision
$version = "0.000001 alpha"

# Command Prompt
$cmdprompt = "evmcmd>"

def login
  load "#{$INSTALL_PATH}/evmcmd.conf.rb"
  # Set up Savon client
  @client = Savon::Client.new do |wsdl, http|
    wsdl.document = "#{$url}"
    http.auth.basic "#{$user}", "#{$password}"
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

def showminimal(id_title, id_value, name_title, name_value)
  puts "#{id_title}: #{id_value}\t #{name_title}: #{name_value}"
end

def ems_version
  login
  response = @client.request :version
  response_hash =  response.to_hash[:version_response][:return]
  version = response_hash[:item].join(sep=".",)
  puts "EMS Version: #{version}"
  return "#{version}"
end
