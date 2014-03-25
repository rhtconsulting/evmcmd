#!/usr/bin/env ruby
require 'rubygems'
require 'json'

class VirtualMachines

  def initialize
    @client = CFMEConnection.instance
  end

  ########################################################################################################################
  def listall(args)
    response = @client.call(:get_vm_list, message: {hostGuid: "all"})
    response_hash =  response.to_hash[:get_vm_list_response][:return]

    if args['--out'] == nil
      output = AddHashToArray(response_hash[:item])
      output.each { |key| showminimal("GUID", "#{key[:guid]}", "name", "#{key[:name]}") }
    end

    if args['--out'] == 'json'
      puts JSON.pretty_generate(response_hash)
    end

  end

  ########################################################################################################################
  def load(guid)
    @msg_details = {}
    ############################################################
    # Virtual Machine
    ############################################################
    puts "# Retrieving VM Detailed information"
    vm = @client.call(:find_vm_by_guid, message: {vmGuid: "#{guid}"})
    vm_hash =  vm.to_hash[:find_vm_by_guid_response][:return]
    vm_details = AddHashToArray(vm_hash)
    vm_details.each { |vm|
      $hostGuid = vm[:host][:guid]
      $clusterId = vm[:parent_cluster][:id]
      $resourcepoolId = vm[:parent_resource_pool][:id]
    }
    if vm_hash.nil?
      puts "vm_hash is empty"
    else
      @msg_details.merge!(:vm_details => vm_hash)
    end

    ############################################################
    # Host
    ############################################################
    puts "# Retrieving Host information for VM"
    host = @client.call(:find_host_by_guid, message: {hostGuid: "#{$hostGuid}"})
    host_hash =  host.to_hash[:find_host_by_guid_response][:return]
    host_details = AddHashToArray(host_hash)
    if host_hash.nil?
      puts "host_hash is empty"
    else
      @msg_details.merge!(:host_details => host_hash)
    end

    ############################################################
    # Cluster
    ############################################################
    puts "# Retrieving Parent Cluster of VM"
    cluster = @client.call(:find_cluster_by_id, message: {clusterId: "#{$clusterId}"})
    cluster_hash =  cluster.to_hash[:find_cluster_by_id_response][:return]
    if cluster_hash.nil?
      puts "cluster_hash is empty"
    else
      @msg_details.merge!(:cluster_details => cluster_hash)
    end

    ############################################################
    # Resource Pools
    ############################################################
    puts "# Retrieving Resource Pools of VM"
    resourcepool = @client.call(:find_resource_pool_by_id, message: {resourcepoolId: "#{$resourcepoolId}"})
    resourcepool_hash =  resourcepool.to_hash[:find_resource_pool_by_id_response][:return]
    if resourcepool_hash.nil?
      puts "resourcepool_hash is empty"
    else
      @msg_details.merge!(:resourcepool_details => resourcepool_hash)
    end

  end

  ########################################################################################################################
  def gettags(args)
    $guid = args['-g']

    if $guid == nil
      puts "Error, you must specify -g GUID or name with a value"
    else
      response = @client.call(:vm_get_tags, message: {vmGuid: "#{$guid}"})
      response_hash =  response.to_hash[:vm_get_tags_response][:return]

      if args['--out'] == nil
        output = AddHashToArray(response_hash[:item])
        output.each { |key| showminimal("Category", "#{key[:category]}", "Tag", "#{key[:tag_display_name]}") }
      end

      if args['--out'] == 'json'
        puts JSON.pretty_generate(response_hash)
      end

    end
  end


  ########################################################################################################################
  def printout(data)
    vm_wsinfo = extractHashes(data[:vm_details][:ws_attributes][:item])
    print   "Properties:\n",
            "\tID:\t\t\t\t#{data[:vm_details][:id]}\n",
            "\tVM GUID:\t\t\t#{data[:vm_details][:guid]}\n",
            "\tEMS ID:\t\t\t\t#{data[:vm_details][:ems_id]}\n",
            "\tName:\t\t\t\t#{data[:vm_details][:name]}\n",
            "\tHostname:\t\t\t#{vm_wsinfo[:hostnames]}\n",
            "\tIP Address:\t\t\t#{vm_wsinfo[:ipaddresses].to_s}\n",
            "\tContainer:\t\t\t#{data[:vm_details][:vendor]} (#{data[:vm_details][:hardware][:numvcpus].to_i} CPUs, #{data[:vm_details][:hardware][:memory_cpu].to_i} MB)\n",
            "\tParent Host Platform:\t\t#{vm_wsinfo[:v_host_vmm_product]}\n",
            "\tPlatform Tools:\t\t\t#{data[:vm_details][:tools_status]}\n",
            "\tOperating System:\t\t#{data[:vm_details][:hardware][:guest_os_full_name]}\n",
            "\tCPU Affinity:\t\t#{data[:vm_details][:cpu_affinity]}\n",
            "\tSnapshots:\t\t\t#{vm_wsinfo[:v_total_snapshots]}\n",
            "\nLifecycle:\n",
            "\tDiscovered:\t\t\t#{data[:vm_details][:created_on]}\n",
            "\tLast Analyzed:\t\t\t#{data[:vm_details][:last_scan_on]}\n",
            "\nRelationships:\n",
                "\tInfrastructure Provider:\t#{data[:vm_details][:ext_management_system][:name]}\n"
                            if data[:host_details] != nil
                              "\tHost:\t\t\t\t#{data[:host_details][:name]}\n"
                            end
                            if data[:cluster_details] != nil
                              print "\tCluster:\t\t\t#{data[:cluster_details][:name]}\n"
                            end
                            if data[:rp_details] != nil
                              print "\tResource Pool:\t\t\t#{data[:rp_details][:name]}\n"
                            end
    print "\tDatastores:\t\t\t#{data[:vm_details][:datastores][:item][:name]}\n",
            "\nCompliance:\n",
            "\tStatus:\t\t\t\t#{vm_wsinfo[:last_compliance_status]}\n",
            "\tHistory:\t\t\t#{vm_wsinfo[:last_compliance_timestamp]}\n",
            "\nPower Management:\n",
            "\tPower State:\t\t\t#{data[:vm_details][:power_state]}\n",
            "\tLast Boot Time:\t\t\t#{data[:vm_details][:boot_time]}\n",
            "\tState Change On:\t\t#{data[:vm_details][:state_changed_on]}\n",
            "\nDatastore Allocation Summary:\n",
           "\tNumber of Disks:\t\t#{vm_wsinfo[:num_disks]}\n",
            "\tDisks Aligned:\t\t\t#{vm_wsinfo[:disks_aligned]}\n",
            "\tThin Provisioning Used:\t\t#{vm_wsinfo[:disk_1_disk_type]}\n",
            "\tDisks:\t\t\t\t#{vm_wsinfo[:disk_1_size]}\n",
            "\tMemory:\t\t\t\t#{data[:vm_details][:hardware][:memory_cpu].to_i / 1024} GB\n",
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
  def bytag(args)
    $tag = args['-t']

    if $tag == nil
      puts "Error: The -t category/category_name is required."
    else
      response = @client.call(:get_vms_by_tag, message: {tag: "#{$tag}"})
      response_hash =  response.to_hash[:get_vms_by_tag_response][:return]

      if args['--out'] == nil
        output = AddHashToArray(response_hash[:item])
        output.each { |key| puts "GUID: #{key[:guid]}\t Name: #{key[:name]}" }
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
    response = @client.call(:vm_set_tag, message: {vmGuid: "#{$guid}", category: "#{$category}", name: "#{$name}"})
    response_hash =  response.to_hash[:vm_set_tag_response][:return]
    gettags(args)
  end

  ########################################################################################################################
  def setowner(args)
    $guid = args['-g']
    $owner = args['-o']

    if $guid == nil
      puts "Error: The -g GUID is required."
      exit
    end
    if $owner == nil
      puts "Error: The -o owner is required."
      exit
    end
    response = @client.call(:vm_set_owner, message: {vmGuid: "#{$guid}", owner: "#{$owner}"})
    response_hash =  response.to_hash[:vm_set_tag_response][:return]
    gettags(args)
  end
end
