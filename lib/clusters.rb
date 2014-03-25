#!/usr/bin/env ruby

class Clusters
	def initialize
		@client = CFMEConnection.instance
	end

	########################################################################################################################
	def listall(args)
	  message_title = "Cluster"
	  response = @client.call(:get_cluster_list, message: {emsGuid: "all"})
	  response_hash =  response.to_hash[:get_cluster_list_response][:return]
    if args['--out'] == nil
      output = AddHashToArray(response_hash[:item])
      output.each { |key| showminimal("ID", "#{key[:id]}", "#{message_title}", "#{key[:name]}") }
    end
    if args['--out'] == 'json'
      puts JSON.pretty_generate(response_hash)
    end
  end

  #####################################################################################
  def getvms(args)
    $id = args['-i']

    if $id == nil
      puts "Error, you must specify -i ID  with a value"
    else
      message_title = "Cluster"
      response = @client.call(:find_cluster_by_id, message: {clusterId: "#{$id}"})
      response_hash =  response.to_hash[:find_cluster_by_id_response][:return][:vms]
      if args['--out'] == nil
        output = AddHashToArray(response_hash[:item])
        output.each { |key| showminimal("GUID", "#{key[:guid]}", "VM", "#{key[:name]}") }
      end
      if args['--out'] == 'json'
        puts JSON.pretty_generate(response_hash)
      end
    end
  end

  #####################################################################################
  def gethosts(args)
    $id = args['-i']

    if $id == nil
      puts "Error, you must specify -i ID  with a value"
    else
      message_title = "Datastore"
      response = @client.call(:find_cluster_by_id, message: {clusterId: "#{$id}"})
      response_hash =  response.to_hash[:find_cluster_by_id_response][:return][:hosts]
      if args['--out'] == nil
        output = AddHashToArray(response_hash[:item])
        output.each { |key| showminimal("GUID", "#{key[:guid]}", "Host", "#{key[:name]}") }
      end
      if args['--out'] == 'json'
        puts JSON.pretty_generate(response_hash)
      end
    end
  end

  #####################################################################################
  def getmgtsys(args)
    $id = args['-i']

    if $id == nil
      puts "Error, you must specify -i ID  with a value"
    else
      message_title = "Datastore"
      response = @client.call(:find_cluster_by_id, message: {clusterId: "#{$id}"})
      response_hash =  response.to_hash[:find_cluster_by_id_response][:return][:ext_management_system]
      if args['--out'] == nil
        showminimal("GUID", "#{response_hash[:guid]}", "EVM", "#{response_hash[:name]}")
      end
      if args['--out'] == 'json'
        puts JSON.pretty_generate(response_hash)
      end
    end
  end

  ########################################################################################################################
  def bytag(args)
    $tag = args['-t']

    if $tag == nil
      puts "Error: The -t category/category_name is required."
    else
      response = @client.call(:get_clusters_by_tag, message: {tag: "#{$tag}"})
      response_hash =  response.to_hash[:get_clusters_by_tag_response][:return]
      if args['--out'] == nil
        output = AddHashToArray(response_hash[:item])
        output.each { |key| puts "ID: #{key[:id]}\t Cluster: #{key[:name]}" }
      end
      if args['--out'] == 'json'
        puts JSON.pretty_generate(response_hash)
      end
    end
  end
end