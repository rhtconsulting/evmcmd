#!/usr/bin/env ruby

class AutomationRequest
  def initialize
    @client = CFMEConnection.instance
  end

  ########################################################################################################################
  def create(args)
    OptionParser.new do |o|
      o.on('-t templateFields') { |template| $template = template }
      o.on('-v vmFields') { |vm| $vm = vm }
      o.on('-r requester') { |requester| $requester = requester }
      o.on('-c tags') { |tags| $tags = tags }
      o.on('-V param=value') { |values| $values = values }
      o.on('-M param=value') { |miq_values| $miq_values = miq_values }
      o.on('-E param=value') { |ems_values| $ems_values = ems_values }
      o.on('-h') { puts o; exit }
      o.parse!
    end

    body_hash = {}
    body_hash['version']            = '1.1'
    body_hash['templateFields'] = "#{$template}"
    body_hash['vmFields']           = "#{$vm}"
    body_hash['requester']          = "#{$requester}"
    body_hash['tags']                       = "#{$tags}"
    body_hash['options']            = { 'values' => "#{$values}", 'miq_custom_attributes' => "#{$miq_values}", 'ems_custom_attributes' => "#{$ems_values}" }

    puts body_hash.inspect

    response = @client.call(:vm_provision_request, message: body_hash)
    request_hash = response.to_hash
    puts "Request Returned: #{request_hash.inspect}"
    puts "Provision Request Id: #{request_hash[:vm_provision_request_response][:return].inspect}"

  end
end
