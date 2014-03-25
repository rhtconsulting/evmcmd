#!/usr/bin/env ruby

load "lib/evmcmd_globals.rb"

class ManagementSystems

  def initialize
    @client = CFMEConnection.instance
  end

  ########################################################################################################################
  def listall(args)
    message_title = "Management System"
    response = @client.call(:get_ems_list, nil) 
    response_hash =  response.to_hash[:get_ems_list_response][:return]
    output = AddHashToArray(response_hash[:item])
    output.each { |key| puts "GUID: #{key[:guid]}\t #{message_title}: #{key[:name]}" }
  end

  ########################################################################################################################
  def load(guid)
    @msg_details = {}
    puts "# Retrieving Management System Details"
    response = @client.call(:find_ems_by_guid, message: {emsGuid: "#{$guid}"})
    response_hash =  response.to_hash[:find_ems_by_guid_response][:return]
    if response_hash.nil?
      puts "host_hash is empty"
    else
      @msg_details.merge!(:mgtsys_details => response_hash)
    end
  end

  ########################################################################################################################
  def gettags(args)
    $guid = args['-g']

    if $guid == nil
      puts "Error, you must specify -g GUID  with a value"
    else
      response = @client.call(:ems_get_tags, message: {emsGuid: "#{$guid}"})
      response_hash =  response.to_hash[:ems_get_tags_response][:return]
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
    $guid = args['-g']
    $category = args['-c']
    $name = args['-n']

    if $guid == nil
      puts "Error: The -g GUID is required."
      exit
    end
    if $category == nil
      puts "Error: The -c category is required."
      exit
    end
    if $name == nil
      puts "Error: The -n category_name is required."
      exit
    end
    response = @client.call(:ems_set_tag, message: {emsGuid: "#{$guid}", category: "#{$category}", name: "#{$name}"})
    response_hash =  response.to_hash[:ems_set_tag_response][:return]
    gettags(args)
  end

  ########################################################################################################################
  def printout(data)
    wsinfo = extractHashes(data[:mgtsys_details][:ws_attributes][:item])
    total_memory = wsinfo[:aggregate_memory].to_f / 1024
    print   "Details:\n",
            "\tID:\t\t\t\t\t#{data[:mgtsys_details][:id]}\n",
            "\tName:\t\t\t\t\t#{data[:mgtsys_details][:name]}\n",
            "\tHostname:\t\t\t\t#{data[:mgtsys_details][:hostname]}\n",
            "\tIP Address:\t\t\t\t#{data[:mgtsys_details][:ipaddress]}\n",
            "\tType:\t\t\t\t\t#{wsinfo[:emstype_description]}\n",
            "\tAggregate Host CPU Resources:\t\t#{wsinfo[:aggregate_cpu_speed].to_f / 1000} Ghz\n",
            "\tAggregate Host Memory\t\t\t#{total_memory.ceil/1} GB\n",
            "\tAggregate Host CPUs:\t\t\t#{wsinfo[:aggregate_physical_cpus]}\n",
            "\tAggregate Host CPU Cores:\t\t#{wsinfo[:aggregate_logical_cpus]}\n",
            "\tManagement Engine GUID:\t\t\t#{data[:mgtsys_details][:guid]}\n",
            "\tAuthentication Status:\t\t\t#{wsinfo[:authentication_status]}\n",
            "\tAPI Version:\t\t\t\t#{data[:mgtsys_details][:api_version]}\n",
            "\nRelationships:\n",
            "\tClusters:\t\t\t\t#{wsinfo[:total_clusters]}\n",
            "\tHosts:\t\t\t\t\t#{wsinfo[:total_hosts]}\n",
            "\tDatastores:\t\t\t\t#{wsinfo[:total_storages]}\n",
            "\tVMs:\t\t\t\t\t#{wsinfo[:total_vms]}\n",
            "\tTemplates:\t\t\t\t#{wsinfo[:total_miq_templates]}\n",
            "\nSmart Management:\n",
            "\tManaged Zone:\t\t\t\t#{wsinfo[:zone_name]}\n"
  end

  ########################################################################################################################
  def details(args)
    $guid = args['-g']
    if $guid == nil
      puts "Error, you must specify -g GUID  with a value"
    else
      load(args['-g'])
      if args['--out'] == nil
        printout(@msg_details)
      end

      if args['--out'] == 'json'
        puts JSON.pretty_generate(@msg_details)
      end

    end
  end

end