#!/usr/bin/env ruby

class Host

  def initialize
    @client = CFMEConnection.instance
  end

  #####################################################################################
  def listall
    #login
    message_title = "Host"
    response = @client.call(:get_host_list, message: {emsGuid: "all"})
    response_hash =  response.to_hash[:get_host_list_response][:return]
    output = AddHashToArray(response_hash[:item])
    output.each { |key| showminimal("GUID", "#{key[:guid]}", "#{message_title}", "#{key[:name]}") }
  end

  #####################################################################################
  def getvms(args)
    OptionParser.new do |o|
      o.on('-g GUID') { |guid| $guid = guid }
      o.on('-h') { puts o; exit }
      o.parse!
    end

    if $guid == nil
      puts "Error, you must specify -g GUID  with a value"
    else
      message_title = "Host"
      response = @client.call(:evm_vm_list, message: {hostGuid: "#{$guid}"})
      response_hash =  response.to_hash[:evm_vm_list_response][:return]
      output = AddHashToArray(response_hash[:item])
      output.each { |key| showminimal("GUID", "#{key[:guid]}", "VM", "#{key[:name]}") }
    end
  end

  ########################################################################################################################
  def gettags(args)
    OptionParser.new do |o|
      o.on('-g GUID') { |guid| $guid = guid }
      o.on('-h') { puts o; exit }
      o.parse!
    end

    if $guid == nil
      puts "Error, you must specify -g GUID  with a value"
    else
      #h = splitOpts(args[0])
      #guid = h['hostGuid']
      #login
      response = @client.call(:host_get_tags, message: {hostGuid: "#{$guid}"})
      response_hash =  response.to_hash[:host_get_tags_response][:return]
      if response_hash[:item] == nil
        puts "No records found"
      else
        output = AddHashToArray(response_hash[:item])
        output.each { |key| showminimal("Category", "#{key[:category_display_name]}", "Tag", "#{key[:tag_display_name]}") }
      end
    end
  end

  #####################################################################################
  def getmgtsys(args)
    OptionParser.new do |o|
      o.on('-g GUID') { |guid| $guid = guid }
      o.on('-h') { puts o; exit }
      o.parse!
    end

    if $guid == nil
      puts "Error, you must specify -g GUID  with a value"
    else
      response = @client.call(:find_host_by_guid, message: {hostGuid: "#{$guid}"})
      response_hash =  response.to_hash[:find_host_by_guid_response][:return][:ext_management_system]
      showminimal("GUID", "#{response_hash[:guid]}", "EVM", "#{response_hash[:name]}")
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
  def printout(host_details,cluster_details,tags_details)
    #puts "#{host_details.inspect}     \n\n"
    @msg_details = { :host_details => host_details }
    @msg_details.merge!(:cluster_details => cluster_details)
    @msg_details.merge!(:tags_details => tags_details)

    ds_count = getcount(@msg_details[:host_details][:datastores][:item])
    rp_count = getcount(@msg_details[:host_details][:resource_pools][:item])
    vm_count = getcount(@msg_details[:host_details][:vms][:item])
    host_wsinfo = extractHashes(@msg_details[:host_details][:ws_attributes][:item])
    tags_info = extractHashes(@msg_details[:tags_details][:item])

    print   "Properties:\n",
            "\tHostname:\t\t\t#{@msg_details[:host_details][:hostname]}\n",
            "\tIP Address:\t\t\t#{@msg_details[:host_details][:ipaddress]}\n",
            "\tIPMI IP Address:\t\twwqwq#{@msg_details[:host_details][:ipmi_address]}\n",
            "\tVMM Information:\t\t#{@msg_details[:host_details][:vmm_vendor]}\n",
            "\tManufacturer/Model:\t\t#{@msg_details[:host_details][:hardware][:manufacturer]}/#{@msg_details[:host_details][:hardware][:model]}\n",
            "\tAsset Tag:\t\t\t#{@msg_details[:host_details][:asset_tag]}\n",
            "\tService Tag:\t\t\t#{@msg_details[:host_details][:service_tag]}\n",
            "\tOperating System:\t\t#{@msg_details[:host_details][:vmm_product]} #{@msg_details[:host_details][:vmm_version]} Build #{@msg_details[:host_details][:vmm_buildnumber]}\n",
            "\tPower State:\t\t\t#{@msg_details[:host_details][:power_state]}\n",
            #        "\tLockdown Mode:\t\t\t#{@msg_details[:host_details][:guid]}\n",
            #       "\tDevices:\t\t\t#{@msg_details[:host_details][:power_state]}\n",
            #        "\tNetwork:\t\t\t#{@msg_details[:host_details][:power_state]}\n",
            "\tStorage Adapters:\t\t#{ds_count}\n",
            "\tNumber of CPUs:\t\t\t#{@msg_details[:host_details][:hardware][:numvcpus].to_i}\n",
            "\tNumber of CPU Cores:\t\t#{@msg_details[:host_details][:hardware][:logical_cpus].to_i}\n",
            "\tCPU Cores Per Socket:\t\t#{@msg_details[:host_details][:hardware][:cores_per_socket].to_i}\n",
            "\tMemory:\t\t\t\t#{@msg_details[:host_details][:hardware][:memory_cpu].to_i / 1024} GB\n",
            "\tManagement Engine GUID:\t\t#{@msg_details[:host_details][:guid]}\n",
            "\nRelationships:\n",
            "\tInfrastructure Provider:\t#{@msg_details[:host_details][:ext_management_system][:name]}\n",
            "\tCluster:\t\t\t#{@msg_details[:cluster_details][:name]}\n",
            "\tDatastores:\t\t\t#{ds_count}\n",
            "\tResource Pool:\t\t\t#{rp_count}\n",
            "\tVMs:\t\t\t\t#{host_wsinfo[:v_total_vms]}\n",
            "\tVM Templates:\t\t\t#{host_wsinfo[:v_total_miq_templates]}\n",
            #        "\nDrift History:\t\t\t#{host[:power_state]}\n",
#            "\nCompliance:\n",
#            "\tStatus:\t\t\t\t#{@msg_details[:host_details][:ext_management_system][:name]}\n",
#            "\tHistory:\t\t\t#{@msg_details[:host_details][:power_state]}\n",
#            "\nConfiguration:\n",
            #            "\tPackages:\t#{@msg_details[:host_details][:ext_management_system][:name]}\n",
            #            "\tServices:\t\t\t#{@msg_details[:host_details][:power_state]}\n",
            #            "\tFiles:\t\t\t#{@msg_details[:host_details][:power_state]}\n",
            #            "\tAdvanced Settings:\t\t\t#{@msg_details[:host_details][:power_state]}\n",
            #            "\tServices:\t\t\t#{@msg_details[:host_details][:power_state]}\n",
            #            "\tServices:\t\t\t#{@msg_details[:host_details][:power_state]}\n",
             "\nSmart Management:\n"
            @msg_details[:tags_details][:item].each { |t|
                       print "\tTags:\t\t\t\t#{t[:category_display_name]}: #{t[:tag_display_name]}\t(#{t[:category]}/#{t[:tag_name]})\n"
            }
            print "\nAuthentication Status:\n",
            "\tDefault Credentials:\t\t#{host_wsinfo[:authentication_status]}\n",
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
      host = @client.call(:find_host_by_guid, message: {hostGuid: "#{$guid}"})
      host_hash =  host.to_hash[:find_host_by_guid_response][:return]
      host_details = AddHashToArray(host_hash)
      host_details.each { |host|
        @hostGuid = host[:guid]
        @clusterId = host[:parent_cluster][:id]
      }
      cluster = @client.call(:find_cluster_by_id, message: {clusterId: "#{@clusterId}"})
      cluster_hash =  cluster.to_hash[:find_cluster_by_id_response][:return]
      tags = @client.call(:host_get_tags, message: {hostGuid: "#{@hostGuid}"})
      tags_hash =  tags.to_hash[:host_get_tags_response][:return]
      printout(host_hash,cluster_hash,tags_hash)
    end
  end

end
