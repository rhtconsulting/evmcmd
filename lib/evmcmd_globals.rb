#!/usr/bin/env ruby

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

########################################################################################################################
def login(*args)
  load "#{$INSTALL_PATH}/evmcmd.conf.rb"
  # Set up Savon client
  @client = Savon::Client.new do |wsdl, http|
    http.auth.ssl.verify_mode = :none
    wsdl.document = "#{$url}"
    http.auth.basic "#{$user}", "#{$password}"
  end
end

########################################################################################################################
def quit(*args)
  send(exit)
end

########################################################################################################################
def exit(*args)
  puts "Goodbye!"
  Process.exit!(true)
end

########################################################################################################################
def parseCli(run_method, run_args)
  unless run_method == "blank"
    send(run_method, run_args)
  end
end

########################################################################################################################
def showminimal(id_title, id_value, name_title, name_value)
  puts "#{id_title}: #{id_value}\t #{name_title}: #{name_value}"
end

########################################################################################################################
def ems_version(*args)
  login
  response = @client.request :version
  response_hash =  response.to_hash[:version_response][:return]
  version = response_hash[:item].join(sep=".",)
  puts "EMS Version: #{version}"
  return "#{version}"
end

########################################################################################################################
def splitOpts(*args)
  $i = 0
  out_hash = {}
  arr = args[0]
  total_var = arr.count
  while $i < total_var do
    tmp_hash = {}
    tmp_a = arr.to_a.slice($i).split(/=/)
    tmp_hash = Hash[*tmp_a.flatten]
    merged_hash = out_hash.merge!(tmp_hash)
    $i +=1
  end
  $i = 0
  return merged_hash
end

########################################################################################################################
def AddHashToArray(obj)
  case obj
    when Array
      return obj
    when Hash
      tmp_a = []
      tmp_a << Hash[*obj.flatten]
      return tmp_a
  end
end

########################################################################################################################
def extractHashes(array)
  newhash = {}
  array.each {|name,value| newhash[:"#{name[:name]}"] = "#{name[:value]}" }
  return newhash
end