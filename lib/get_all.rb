#!/usr/bin/env ruby

def get_allmanagementsystems
  login
  message_title = "Management System"
  # Query CFME web-service
  response = @client.request "GetEmsList"

  # Convert response to hash
  response_hash =  response.to_hash[:get_ems_list_response][:return]
  #puts "CFME web-service returned: #{response_hash.inspect}"

  # Loop through each management system in the array and log the name and guid
  response_hash[:item].each { |key| puts "#{message_title}: #{key[:name].inspect}\tGUID: #{key[:guid].inspect}" }
end

def get_allhosts
  login
  message_title = "Host"
  response = @client.request :get_host_list do
    soap.body = { :emsGuid => "all" }
  end
  response_hash =  response.to_hash[:get_host_list_response][:return]
  response_hash[:item].each { |key| showminimal("GUID", "#{key[:guid].inspect}", "#{message_title}", "#{key[:name].inspect}") }
end

def get_allvms
  login
  message_title = "VM"
  response = @client.request :get_vm_list do
    soap.body = { :hostGuid => "all" }
  end
  response_hash =  response.to_hash[:get_vm_list_response][:return]
  response_hash[:item].each { |key| showminimal("GUID", "#{key[:guid].inspect}", "#{message_title}", "#{key[:name].inspect}") }
end

def get_allclusters
  login
  message_title = "Cluster"
  response = @client.request :get_cluster_list do
    soap.body = { :emsGuid => "all" }
  end
  response_hash =  response.to_hash[:get_cluster_list_response][:return]
  response_hash[:item].each { |key| showminimal("ID", "#{key[:id].inspect}", "#{message_title}", "#{key[:name].inspect}") }
end

def get_allresourcepools
  login
  message_title = "Resource Pool"
  response = @client.request :get_resource_pool_list do
    soap.body = { :emsGuid => "all" }
  end
  response_hash =  response.to_hash[:get_resource_pool_list_response][:return]
  response_hash[:item].each { |key| showminimal("ID", "#{key[:id].inspect}", "#{message_title}", "#{key[:name].inspect}") }
end

def get_alldatastores
  login
  message_title = "Datastore"
  response = @client.request :get_datastore_list do
    soap.body = { :emsGuid => "all" }
  end
  response_hash =  response.to_hash[:get_datastore_list_response][:return]
  response_hash[:item].each { |key| showminimal("ID", "#{key[:id].inspect}", "#{message_title}", "#{key[:name].inspect}") }
end
