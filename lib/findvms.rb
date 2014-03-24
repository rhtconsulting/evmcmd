#!/usr/bin/env ruby

class FindVms
  def initialize
    @client = CFMEConnection.instance
  end

  ########################################################################################################################
  def bytag(tag)
    if tag == nil
      puts "Error: The Tag is required."
    else
      response = @client.call(:get_vms_by_tag, message: {tag: "#{tag}"})
      response_hash =  response.to_hash[:get_vms_by_tag_response][:return]
      output = AddHashToArray(response_hash[:item]) 
      output.each { |key| puts "GUID: #{key[:guid]}\t Name: #{key[:name]}" }
    end
  end
end
