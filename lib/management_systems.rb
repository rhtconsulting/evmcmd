#!/usr/bin/env ruby

load "lib/evmcmd_globals.rb"

class ManagementSystems

  def initialize
    @client = CFMEConnection.instance
  end

  ########################################################################################################################
  def listall
    message_title = "Management System"
    response = @client.call(:get_ems_list, nil) 
    response_hash =  response.to_hash[:get_ems_list_response][:return]
    output = AddHashToArray(response_hash[:item])
    output.each { |key| puts "GUID: #{key[:guid]}\t #{message_title}: #{key[:name]}" }
  end

  ########################################################################################################################
  def gettags(emsGuid)
    if emsGuid == nil
      puts "Error, you must specify emsGuid or name with a value"
    else
      #h = splitOpts(args[0])
      #emsGuid = h['emsGuid']
      #login
      response = @client.call( :ems_get_tags, message: {emsGuid: "#{emsGuid}"} )
      response_hash =  response.to_hash[:ems_get_tags_response][:return]
      if response_hash[:item] == nil
        puts "No records found"
      else
        output = AddHashToArray(response_hash[:item])
        puts output.inspect
        output.each { |key| showminimal("Category", "#{key[:category]}", "Tag", "#{key[:tag_display_name]}") }
      end
    end
  end

  ########################################################################################################################
  def settags(emsGuid, category, name)
    help =  "Usage: managementsystem_settags [OPTIONS]
            emsGuid=<unique identifier>
            category=<category>
            name=<name>               "
    if emsGui == nil || category == nil || name == nil
          puts help
    else
      #h = splitOpts(args[0])
      #emsGuid = h['emsGuid']
      #category = h['category']
      #name = h['name']
      #login
      #body_hash = {}
      #body_hash['emsGuid'] =  "#{emsGuid}"
      #body_hash['category'] =  "#{category}"
      #body_hash['name'] =  "#{name}"

      response = @client.call(:ems_set_tag, message: {emsGuid: "#{emsGuid}", category: "#{category}", name: "#{name}"})
      puts "Response: #{response}"    
    end
  end

  ########################################################################################################################
  def details(emsGuid)
    if emsGuid == nil
      puts "Error, you must specify emsGuid or name with a value"
    else
      #h = splitOpts(args[0])
      #emsGuid = h['emsGuid']
      #login
      response = @client.call(:find_ems_by_guid, message: {emsGuid: "#{emsGuid}"})
      response_hash =  response.to_hash[:find_ems_by_guid_response][:return]
      output = AddHashToArray(response_hash)
      output.each {|key|    wsinfo = extractHashes(key[:ws_attributes][:item])
      total_memory = wsinfo[:aggregate_memory].to_f / 1024
      print   "Details:\n",
                    "\tID:\t\t\t\t\t#{key[:id]}\n",
                    "\tName:\t\t\t\t\t#{key[:name]}\n",
                    "\tHostname:\t\t\t\t#{key[:hostname]}\n",
                    "\tIP Address:\t\t\t\t#{key[:ipaddress]}\n",
                    "\tType:\t\t\t\t\t#{wsinfo[:emstype_description]}\n",
                    "\tAggregate Host CPU Resources:\t\t#{wsinfo[:aggregate_cpu_speed].to_f / 1000} Ghz\n",
                    "\tAggregate Host Memory\t\t\t#{total_memory.ceil/1} GB\n",
                    "\tAggregate Host CPUs:\t\t\t#{wsinfo[:aggregate_physical_cpus]}\n",
                    "\tAggregate Host CPU Cores:\t\t#{wsinfo[:aggregate_logical_cpus]}\n",
                    "\tManagement Engine GUID:\t\t\t#{key[:guid]}\n",
                    "\tAuthentication Status:\t\t\t#{wsinfo[:authentication_status]}\n",
                    "\tAPI Version:\t\t\t\t#{key[:api_version]}\n",
              "\nRelationships:\n",
                    "\tClusters:\t\t\t\t#{wsinfo[:total_clusters]}\n",
                    "\tHosts:\t\t\t\t\t#{wsinfo[:total_hosts]}\n",
                    "\tDatastores:\t\t\t\t#{wsinfo[:total_storages]}\n",
                    "\tVMs:\t\t\t\t\t#{wsinfo[:total_vms]}\n",
                    "\tTemplates:\t\t\t\t#{wsinfo[:total_miq_templates]}\n",
              "\nSmart Management:\n",
                    "\tManaged Zone:\t\t\t\t#{wsinfo[:zone_name]}\n"
      }
    end
  end
end