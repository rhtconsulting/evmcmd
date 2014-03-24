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
  def getvms(hostGuid)
    #login
    if hostGuid == nil
      puts "Error, you must specify hostGuid"
    else
      message_title = "Host"
      response = @client.call(:evm_vm_list, message: {hostGuid: "#{hostGuid}"})
      response_hash =  response.to_hash[:evm_vm_list_response][:return]
      output = AddHashToArray(response_hash[:item])
      output.each { |key| showminimal("GUID", "#{key[:guid]}", "VM", "#{key[:name]}") }
    end
  end

  ########################################################################################################################
  def gettags(hostGuid)
    if hostGuid == nil
      puts "Error, you must specify hostGuid"
    else
      #h = splitOpts(args[0])
      #guid = h['hostGuid']
      #login
      response = @client.call(:host_get_tags, message: {hostGuid: "#{hostGuid}"})
      response_hash =  response.to_hash[:host_get_tags_response][:return]
      if response_hash[:item] == nil
        puts "No records found"
      else
        output = AddHashToArray(response_hash[:item])
        output.each { |key| showminimal("Category", "#{key[:category_display_name]}", "Tag", "#{key[:tag_display_name]}") }
      end
    end
  end
end
