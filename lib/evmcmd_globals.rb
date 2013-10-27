#!/usr/bin/env ruby

load './lib/get_all.rb'

# Revision
$version = "0.000001 alpha"

# Command Prompt
$cmdprompt = "evmcmd>"

def login
  load './evmcmd.conf.rb'
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
