#!/usr/bin/env ruby

class ResourcePool
	def initialize
		@client = CFMEConnection.instance
	end

  ########################################################################################################################
	def listall(args)
	  message_title = "Resource Pool"
	  response = @client.call( :get_resource_pool_list, message:{ emsGuid: "all" } )
	  response_hash =  response.to_hash[:get_resource_pool_list_response][:return]
    if args['--out'] == nil
      output = AddHashToArray(response_hash[:item])
      output.each { |key| showminimal("ID", "#{key[:id]}", "#{message_title}", "#{key[:name]}") }
    end
    if args['--out'] == 'json'
      puts JSON.pretty_generate(response_hash)
    end
  end

  #####################################################################################
  def gethosts(args)
    $id = args['-i']

    if $id == nil
      puts "Error, you must specify -i ID  with a value"
    else
      message_title = "Datastore"
      response = @client.call(:find_resource_pool_by_id, message: {resourcepoolId: "#{$id}"})
      response_hash =  response.to_hash[:find_resource_pool_by_id_response][:return][:hosts]
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
      response = @client.call(:find_resource_pool_by_id, message: {resourcepoolId: "#{$id}"})
      response_hash =  response.to_hash[:find_resource_pool_by_id_response][:return][:ext_management_system]
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
      response = @client.call(:get_resource_pools_by_tag, message: {tag: "#{$tag}"})
      response_hash =  response.to_hash[:get_resource_pools_by_tag_response][:return]
      if args['--out'] == nil
        output = AddHashToArray(response_hash[:item])
        output.each { |key| puts "ID: #{key[:id]}\t Cluster: #{key[:name]}" }
      end
      if args['--out'] == 'json'
        puts JSON.pretty_generate(response_hash)
      end
    end
  end

  #####################################################################################
  def getvms(args)
    $id = args['-i']

    if $id == nil
      puts "Error, you must specify -i ID  with a value"
    else
      message_title = "Cluster"
      response = @client.call(:find_resource_pool_by_id, message: {resourcepoolId: "#{$id}"})
      response_hash =  response.to_hash[:find_resource_pool_by_id_response][:return][:vms]
      if args['--out'] == nil
        output = AddHashToArray(response_hash[:item])
        output.each { |key| showminimal("GUID", "#{key[:guid]}", "VM", "#{key[:name]}") }
      end
      if args['--out'] == 'json'
        puts JSON.pretty_generate(response_hash)
      end
    end
  end

  ########################################################################################################################
  def gettags(args)
    $id = args['-i']

    if $id == nil
      puts "Error, you must specify -i ID  with a value"
    else
      #h = splitOpts(args[0])
      #guid = h['hostGuid']
      #login
      response = @client.call(:resource_pool_get_tags, message: {resourcepoolId: "#{$id}"})
      response_hash =  response.to_hash[:resource_pool_get_tags_response][:return]
      if args['--out'] == nil
        if response_hash[:item] == nil
          puts "No records found"
        else
          output = AddHashToArray(response_hash[:item])
          output.each { |key| showminimal("Category", "#{key[:category_display_name]}", "Tag", "#{key[:tag_display_name]}") }
        end
      end
      if args['--out'] == 'json'
        puts JSON.pretty_generate(response_hash)
      end
    end
  end

  ########################################################################################################################
  def settag(args)
    $id = args['-i']
    $category = args['-c']
    $name = args['-n']

    if $id == nil
      puts "Error: The -i ID is required."
      return
    end
    if $category == nil
      puts "Error: The -c category is required."
      return
    end
    if $name == nil
      puts "Error: The -n category_name is required."
      return
    end
    response = @client.call(:resource_pool_set_tag, message: {resourcepoolId: "#{$id}", category: "#{$category}", name: "#{$name}"})
    response_hash =  response.to_hash[:resource_pool_set_tag_response][:return]
    gettags(args)
  end

end
