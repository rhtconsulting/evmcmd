#!/usr/bin/env ruby

########################################################################################################################
def virtualmachine_listall(*args)
  login
  message_title = "VM"
  response = @client.request :get_vm_list do
    soap.body = { :hostGuid => "all" }
  end
  response_hash =  response.to_hash[:get_vm_list_response][:return]
  output = AddHashToArray(response_hash[:item])
  output.each { |key| showminimal("GUID", "#{key[:guid]}", "#{message_title}", "#{key[:name]}") }
end

########################################################################################################################
def virtualmachine_gettags(*args)
  if args[0] == "default"
    puts "Error, you must specify ID or name with a value"
  else
    h = splitOpts(args[0])
    vmGuid = h['vmGuid']
    login
    response = @client.request :vm_get_tags do
      soap.body = { :vmGuid => "#{vmGuid}" }
    end
    response_hash =  response.to_hash[:vm_get_tags_response][:return]
    output = AddHashToArray(response_hash[:item])
    output.each { |key| showminimal("Category", "#{key[:category]}", "Tag", "#{key[:tag_display_name]}") }
  end
end

########################################################################################################################
def virtualmachine_details(*args)
  if args[0] == "default"
    puts "Error, you must specify vmGuid or name with a value"
  else
    h = splitOpts(args[0])
    vmGuid = h['vmGuid']
    login
    response = @client.request :find_vm_by_guid do
      soap.body = { :vmGuid => "#{vmGuid}" }
    end
    response_hash =  response.to_hash[:find_vm_by_guid_response][:return]
    output = AddHashToArray(response_hash)
    output.each {|key|    wsinfo = extractHashes(key[:ws_attributes][:item])
    total_memory = wsinfo[:aggregate_memory].to_f / 1024
    print   "Properties:\n",
              "\tID:\t\t\t\t#{key[:id]}\n",
              "\tName:\t\t\t\t#{key[:name]}\n",
              "\tManagement Engine GUID:\t\t#{key[:guid]}\n",
              "\tServer:\t\t\t\t#{key[:ems_id]}\n",
              "\tHost:\t\t\t\t#{wsinfo[:hostnames]}\n",
              "\tIP Address:\t\t\t#{wsinfo[:ipaddresses]}\n",
              "\tContainer:\t\t\t#{key[:vendor]} (#{key[:hardware][:numvcpus].to_i} CPUs, #{key[:hardware][:memory_cpu].to_i} MB)\n",
              "\tParent Host Platform:\t\t#{wsinfo[:v_host_vmm_product]}\n",
              "\tPlatform Tools:\t\t\t#{key[:tools_status]}\n",
              "\tOperating System:\t\t#{key[:hardware][:guest_os_full_name]}\n",
              "\tSnapshots:\t\t\t#{wsinfo[:v_total_snapshots]}\n",
              "\nLifecycle:\n",
              "\tDiscovered:\t\t\t#{key[:created_on]}\n",
              "\tLast Analyzed:\t\t\t#{key[:last_scan_on]}\n",
              "\nRelationships:\n",
              "\tInfrastructure Provider:\t#{key[:ext_management_system][:name]}\n",
              "\tCluster:\t\t\t#{key[:parent_cluster][:name]}\n",
              "\tHost:\t\t\t\t#{key[:host][:name]}\n",
              "\tResource Pool:\t\t\t#{key[:parent_resource_pool][:name]}\n",
              "\tDatastores:\t\t\t#{key[:datastores][:name]}\n",
              "\nCompliance:\n",
              "\tStatus:\t\t\t\t#{wsinfo[:last_compliance_status]}\n",
              "\tHistory:\t\t\t#{wsinfo[:last_compliance_timestamp]}\n",
              "\nPower Management:\n",
              "\tPower State:\t\t\t#{key[:power_state]}\n",
              "\tLast Boot Time:\t\t\tasdsa#{key[:boot_time]}\n",
              "\tState Change On:\t\t#{key[:state_changed_on]}\n",
              "\nDatastore Allocation Summary:\n",
              "\tNumber of Disks:\t\t#{wsinfo[:num_disks]}\n",
              "\tDisks Aligned:\t\t\t#{wsinfo[:disks_aligned]}\n",
              "\tThin Provisioning Used:\t\t#{wsinfo[:disk_1_disk_type]}\n",
              "\tDisks:\t\t\t\t#{wsinfo[:disk_1_size]}\n",
              "\tMemory:\t\t\t\t#{key[:hardware][:memory_cpu].to_i / 1024} GB\n",

              ""
    }
  end
end
