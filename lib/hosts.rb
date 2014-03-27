#!/usr/bin/env ruby

class Host

  def initialize
    @client = CFMEConnection.instance
  end

  #####################################################################################
  def listall(args)
    message_title = "Host"
    response = @client.call(:get_host_list, message: {emsGuid: "all"})
    response_hash =  response.to_hash[:get_host_list_response][:return]
    if args['--out'] == nil
      output = AddHashToArray(response_hash[:item])
      output.each { |key| showminimal("GUID", "#{key[:guid]}", "#{message_title}", "#{key[:name]}") }
    end
    if args['--out'] == 'json'
      puts JSON.pretty_generate(response_hash)
    end
  end

  def load(guid)
    @msg_details = {}
    ############################################################
    # Host
    ############################################################
    puts "# Retrieving Host Details"
    host = @client.call(:find_host_by_guid, message: {hostGuid: "#{guid}"})
    host_hash =  host.to_hash[:find_host_by_guid_response][:return]
    host_details = AddHashToArray(host_hash)
    host_details.each { |host|
      @hostGuid = host[:guid]
      @clusterId = host[:parent_cluster][:id]
    }
    if host_hash.nil?
      puts "host_hash is empty"
    else
      @msg_details.merge!(:host_details => host_hash)
    end

    ############################################################
    # Cluster
    ############################################################
    puts "# Retrieving Cluster deatails for Host"
    cluster = @client.call(:find_cluster_by_id, message: {clusterId: "#{@clusterId}"})
    cluster_hash =  cluster.to_hash[:find_cluster_by_id_response][:return]
    if cluster_hash.nil?
      puts "cluster_hash is empty"
    else
      @msg_details.merge!(:cluster_details => cluster_hash)
    end

    ############################################################
    # Tags
    ############################################################
    puts "# Retrieving Tags for the Host"
    tags = @client.call(:host_get_tags, message: {hostGuid: "#{@hostGuid}"})
    tags_hash =  tags.to_hash[:host_get_tags_response][:return]
    if tags_hash.nil?
      puts "tags_hash is empty"
    else
      @msg_details.merge!(:tag_details => tags_hash)
    end
  end

  #####################################################################################
  def getvms(args)
    $guid = args['-g']

    if $guid == nil
      puts "Error, you must specify -g GUID  with a value"
    else
      message_title = "Host"
      response = @client.call(:evm_vm_list, message: {hostGuid: "#{$guid}"})
      response_hash =  response.to_hash[:evm_vm_list_response][:return]
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
    $guid = args['-g']

    if $guid == nil
      puts "Error, you must specify -g GUID  with a value"
    else
      #h = splitOpts(args[0])
      #guid = h['hostGuid']
      #login
      response = @client.call(:host_get_tags, message: {hostGuid: "#{$guid}"})
      response_hash =  response.to_hash[:host_get_tags_response][:return]
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

  #####################################################################################
  def getmgtsys(args)
    $guid = args['-g']

    if $guid == nil
      puts "Error, you must specify -g GUID  with a value"
    else
      response = @client.call(:find_host_by_guid, message: {hostGuid: "#{$guid}"})
      response_hash =  response.to_hash[:find_host_by_guid_response][:return][:ext_management_system]
      if args['--out'] == nil
        showminimal("GUID", "#{response_hash[:guid]}", "EVM", "#{response_hash[:name]}")
      end
      if args['--out'] == 'json'
        puts JSON.pretty_generate(response_hash)
      end
    end
  end

  #####################################################################################
  def getcount(data)
    if data.nil?
      return 0
    else
      return data.count
    end
  end

  #####################################################################################
  def printout(data)
    ds_count = getcount(data[:host_details][:datastores][:item])
    rp_count = getcount(data[:host_details][:resource_pools][:item])
    vm_count = getcount(data[:host_details][:vms][:item])
    host_wsinfo = extractHashes(data[:host_details][:ws_attributes][:item])
    tags_info = extractHashes(data[:tag_details][:item])

    print   "Properties:\n",
            "\tHostname:\t\t\t#{data[:host_details][:hostname]}\n",
            "\tIP Address:\t\t\t#{data[:host_details][:ipaddress]}\n",
            "\tIPMI IP Address:\t\twwqwq#{data[:host_details][:ipmi_address]}\n",
            "\tVMM Information:\t\t#{data[:host_details][:vmm_vendor]}\n",
            "\tManufacturer/Model:\t\t#{data[:host_details][:hardware][:manufacturer]}/#{data[:host_details][:hardware][:model]}\n",
            "\tAsset Tag:\t\t\t#{data[:host_details][:asset_tag]}\n",
            "\tService Tag:\t\t\t#{data[:host_details][:service_tag]}\n",
            "\tOperating System:\t\t#{data[:host_details][:vmm_product]} #{data[:host_details][:vmm_version]} Build #{data[:host_details][:vmm_buildnumber]}\n",
            "\tPower State:\t\t\t#{data[:host_details][:power_state]}\n",
            #        "\tLockdown Mode:\t\t\t#{data[:host_details][:guid]}\n",
            #       "\tDevices:\t\t\t#{data[:host_details][:power_state]}\n",
            #        "\tNetwork:\t\t\t#{data[:host_details][:power_state]}\n",
            "\tStorage Adapters:\t\t#{ds_count}\n",
            "\tNumber of CPUs:\t\t\t#{data[:host_details][:hardware][:numvcpus].to_i}\n",
            "\tNumber of CPU Cores:\t\t#{data[:host_details][:hardware][:logical_cpus].to_i}\n",
            "\tCPU Cores Per Socket:\t\t#{data[:host_details][:hardware][:cores_per_socket].to_i}\n",
            "\tMemory:\t\t\t\t#{data[:host_details][:hardware][:memory_cpu].to_i / 1024} GB\n",
            "\tManagement Engine GUID:\t\t#{data[:host_details][:guid]}\n",
            "\nRelationships:\n",
            "\tInfrastructure Provider:\t#{data[:host_details][:ext_management_system][:name]}\n",
            "\tCluster:\t\t\t#{data[:cluster_details][:name]}\n",
            "\tDatastores:\t\t\t#{ds_count}\n",
            "\tResource Pool:\t\t\t#{rp_count}\n",
            "\tVMs:\t\t\t\t#{host_wsinfo[:v_total_vms]}\n",
            "\tVM Templates:\t\t\t#{host_wsinfo[:v_total_miq_templates]}\n",
            #        "\nDrift History:\t\t\t#{host[:power_state]}\n",
#            "\nCompliance:\n",
#            "\tStatus:\t\t\t\t#{data[:host_details][:ext_management_system][:name]}\n",
#            "\tHistory:\t\t\t#{data[:host_details][:power_state]}\n",
#            "\nConfiguration:\n",
            #            "\tPackages:\t#{data[:host_details][:ext_management_system][:name]}\n",
            #            "\tServices:\t\t\t#{data[:host_details][:power_state]}\n",
            #            "\tFiles:\t\t\t#{data[:host_details][:power_state]}\n",
            #            "\tAdvanced Settings:\t\t\t#{data[:host_details][:power_state]}\n",
            #            "\tServices:\t\t\t#{data[:host_details][:power_state]}\n",
            #            "\tServices:\t\t\t#{data[:host_details][:power_state]}\n",
             "\nSmart Management:\n"
            data[:tag_details][:item].each { |t|
                       print "\tTags:\t\t\t\t#{t[:category_display_name]}: #{t[:tag_display_name]}\t(#{t[:category]}/#{t[:tag_name]})\n"
            }
            print "\nAuthentication Status:\n",
            "\tDefault Credentials:\t\t#{host_wsinfo[:authentication_status]}\n",
            ""
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

  ########################################################################################################################
  def settag(args)
    $guid = args['-g']
    $category = args['-c']
    $name = args['-n']

    if $guid == nil
      puts "Error: The -g GUID is required."
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
    response = @client.call(:host_set_tag, message: {hostGuid: "#{$guid}", category: "#{$category}", name: "#{$name}"})
    response_hash =  response.to_hash[:host_set_tag_response][:return]
    gettags(args)
  end

end
