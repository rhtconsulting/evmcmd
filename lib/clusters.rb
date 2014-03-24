#!/usr/bin/env ruby

class Clusters
	def initialize
		@client = CFMEConnection.instance
	end

	########################################################################################################################
	def listall
	  #login
	  message_title = "Cluster"
	  response = @client.call(:get_cluster_list, message: {emsGuid: "all"})
	  response_hash =  response.to_hash[:get_cluster_list_response][:return]
	  output = AddHashToArray(response_hash[:item])
	  output.each { |key| showminimal("ID", "#{key[:id]}", "#{message_title}", "#{key[:name]}") }
  end

  #####################################################################################
  def getvms(args)
    OptionParser.new do |o|
      o.on('-i ID') { |id| $id = id }
      o.on('-h') { puts o; exit }
      o.parse!
    end

    if $id == nil
      puts "Error, you must specify -i ID  with a value"
    else
      message_title = "Cluster"
      response = @client.call(:find_cluster_by_id, message: {clusterId: "#{$id}"})
      response_hash =  response.to_hash[:find_cluster_by_id_response][:return][:vms]
      output = AddHashToArray(response_hash[:item])
      output.each { |key| showminimal("GUID", "#{key[:guid]}", "VM", "#{key[:name]}") }
    end
  end

  #####################################################################################
  def gethosts(args)
    OptionParser.new do |o|
      o.on('-i ID') { |id| $id = id }
      o.on('-h') { puts o; exit }
      o.parse!
    end

    if $id == nil
      puts "Error, you must specify -i ID  with a value"
    else
      message_title = "Datastore"
      response = @client.call(:find_cluster_by_id, message: {clusterId: "#{$id}"})
      response_hash =  response.to_hash[:find_cluster_by_id_response][:return][:hosts]
      output = AddHashToArray(response_hash[:item])
      output.each { |key| showminimal("GUID", "#{key[:guid]}", "Host", "#{key[:name]}") }
    end
  end

  #####################################################################################
  def getmgtsys(args)
    OptionParser.new do |o|
      o.on('-i ID') { |id| $id = id }
      o.on('-h') { puts o; exit }
      o.parse!
    end

    if $id == nil
      puts "Error, you must specify -i ID  with a value"
    else
      message_title = "Datastore"
      response = @client.call(:find_cluster_by_id, message: {clusterId: "#{$id}"})
      response_hash =  response.to_hash[:find_cluster_by_id_response][:return][:ext_management_system]
      showminimal("GUID", "#{response_hash[:guid]}", "EVM", "#{response_hash[:name]}")
    end
  end

  ########################################################################################################################
  def bytag(args)
    OptionParser.new do |o|
      o.on('-t TAG') { |tag| $tag = tag }
      o.on('-h') { puts o; exit }
      o.parse!
    end
    if $tag == nil
      puts "Error: The -t category/category_name is required."
    else
      response = @client.call(:get_clusters_by_tag, message: {tag: "#{$tag}"})
      response_hash =  response.to_hash[:get_clusters_by_tag_response][:return]
      output = AddHashToArray(response_hash[:item])
      output.each { |key| puts "ID: #{key[:id]}\t Cluster: #{key[:name]}" }
    end
  end
end