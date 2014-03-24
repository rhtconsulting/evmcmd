#!/usr/bin/env ruby

class VirtualMachines

  def initialize
    @client = CFMEConnection.instance
  end

  ########################################################################################################################
  def listall
    response = @client.call(:get_vm_list, message: {hostGuid: "all"})
    response_hash =  response.to_hash[:get_vm_list_response][:return]
    output = AddHashToArray(response_hash[:item])
    output.each { |key| showminimal("GUID", "#{key[:guid]}", "name", "#{key[:name]}") }
  end

  ########################################################################################################################
  def gettags(args)
    OptionParser.new do |o|
      o.on('-g GUID') { |guid| $guid = guid }
      o.on('-h') { puts o; exit }
      o.parse!
    end
    if $guid == nil
      puts "Error, you must specify -g GUID or name with a value"
    else
      response = @client.call(:vm_get_tags, message: {vmGuid: "#{$guid}"})
      response_hash =  response.to_hash[:vm_get_tags_response][:return]
      output = AddHashToArray(response_hash[:item])
      output.each { |key| showminimal("Category", "#{key[:category]}", "Tag", "#{key[:tag_display_name]}") }
    end
  end


  ########################################################################################################################
  def printout(vm_details,host_details,cluster_details,rp_details)
#    puts vm_details.inspect
#    puts host_details.inspect
#    puts cluster_details.inspect
    @msg_details = { :vm_details => vm_details }
    @msg_details.merge!(:host_details => host_details)
    @msg_details.merge!(:cluster_details => cluster_details)
    @msg_details.merge!(:rp_details => rp_details)
    vm_wsinfo = extractHashes(@msg_details[:vm_details][:ws_attributes][:item])
    print   "Properties:\n",
#            "\tID:\t\t\t\t#{@msg_details[:vm_details][:id]}\n",
            "\tVM GUID:\t\t\t#{@msg_details[:vm_details][:guid]}\n",
            "\tEMS ID:\t\t\t\t#{@msg_details[:vm_details][:ems_id]}\n",
            "\tName:\t\t\t\t#{@msg_details[:vm_details][:name]}\n",
            "\tHostname:\t\t\t#{vm_wsinfo[:hostnames]}\n",
            "\tIP Address:\t\t\t#{vm_wsinfo[:ipaddresses].to_s}\n",
            "\tContainer:\t\t\t#{@msg_details[:vm_details][:vendor]} (#{@msg_details[:vm_details][:hardware][:numvcpus].to_i} CPUs, #{@msg_details[:vm_details][:hardware][:memory_cpu].to_i} MB)\n",
            "\tParent Host Platform:\t\t#{vm_wsinfo[:v_host_vmm_product]}\n",
            "\tPlatform Tools:\t\t\t#{@msg_details[:vm_details][:tools_status]}\n",
            "\tOperating System:\t\t#{@msg_details[:vm_details][:hardware][:guest_os_full_name]}\n",
            "\tCPU Affinity:\t\t#{@msg_details[:vm_details][:cpu_affinity]}\n",
            "\tSnapshots:\t\t\t#{vm_wsinfo[:v_total_snapshots]}\n",
            "\nLifecycle:\n",
            "\tDiscovered:\t\t\t#{@msg_details[:vm_details][:created_on]}\n",
            "\tLast Analyzed:\t\t\t#{@msg_details[:vm_details][:last_scan_on]}\n",
            "\nRelationships:\n",
                          "\tInfrastructure Provider:\t#{@msg_details[:vm_details][:ext_management_system][:name]}\n",
                          "\tCluster:\t\t\t#{@msg_details[:cluster_details][:name]}\n",
                          "\tHost:\t\t\t\t#{@msg_details[:host_details][:name]}\n",
                          "\tResource Pool:\t\t\t#{@msg_details[:rp_details][:name]}\n",
            "\tDatastores:\t\t\t#{@msg_details[:vm_details][:datastores][:item][:name]}\n",
            "\nCompliance:\n",
            "\tStatus:\t\t\t\t#{vm_wsinfo[:last_compliance_status]}\n",
            "\tHistory:\t\t\t#{vm_wsinfo[:last_compliance_timestamp]}\n",
            "\nPower Management:\n",
            "\tPower State:\t\t\t#{@msg_details[:vm_details][:power_state]}\n",
            "\tLast Boot Time:\t\t\t#{@msg_details[:vm_details][:boot_time]}\n",
            "\tState Change On:\t\t#{@msg_details[:vm_details][:state_changed_on]}\n",
            "\nDatastore Allocation Summary:\n",
            "\tNumber of Disks:\t\t#{vm_wsinfo[:num_disks]}\n",
            "\tDisks Aligned:\t\t\t#{vm_wsinfo[:disks_aligned]}\n",
            "\tThin Provisioning Used:\t\t#{vm_wsinfo[:disk_1_disk_type]}\n",
            "\tDisks:\t\t\t\t#{vm_wsinfo[:disk_1_size]}\n",
            "\tMemory:\t\t\t\t#{@msg_details[:vm_details][:hardware][:memory_cpu].to_i / 1024} GB\n",
           ""
  end

  ########################################################################################################################
  def details(args)
    OptionParser.new do |o|
      o.on('-g GUID') { |guid| $guid = guid }
      o.on('-h') { puts o; exit }
      o.parse!
    end

    if $guid == nil
      puts "Error, you must specify -g GUID  with a value"
    else
      vm = @client.call(:find_vm_by_guid, message: {vmGuid: "#{$guid}"})
      vm_hash =  vm.to_hash[:find_vm_by_guid_response][:return]
      vm_details = AddHashToArray(vm_hash)
      vm_details.each { |vm|
        @hostGuid = vm[:host][:guid]
        @clusterId = vm[:parent_cluster][:id]
        @resourcepoolId = vm[:parent_resource_pool][:id]
      }
      host = @client.call(:find_host_by_guid, message: {hostGuid: "#{@hostGuid}"})
      host_hash =  host.to_hash[:find_host_by_guid_response][:return]
      host_details = AddHashToArray(host_hash)
      cluster = @client.call(:find_cluster_by_id, message: {clusterId: "#{@clusterId}"})
      cluster_hash =  cluster.to_hash[:find_cluster_by_id_response][:return]
      resourcepool = @client.call(:find_resource_pool_by_id, message: {resourcepoolId: "#{@resourcepoolId}"})
      resourcepool_hash =  resourcepool.to_hash[:find_resource_pool_by_id_response][:return]
      printout(vm_hash,host_hash,cluster_hash,resourcepool_hash)
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
      response = @client.call(:get_vms_by_tag, message: {tag: "#{$tag}"})
      response_hash =  response.to_hash[:get_vms_by_tag_response][:return]
      output = AddHashToArray(response_hash[:item])
      output.each { |key| puts "GUID: #{key[:guid]}\t Name: #{key[:name]}" }
    end
  end
end
