#!/usr/bin/env ruby

class AutomationRequest
  def initialize
    @client = CFMEConnection.instance
  end

  ########################################################################################################################
  def create(namespace)
response = @client.call(:create_automation_request, message: {version: "1.1", uri_parts: "namespace=#{namespace}|class=Methods|instance=InspectME|message=create", parameters: "parm1=parameter1|parm2=parameter2", requester: "user_name=admin|owner_last_name=Lastname|owner_first_name=Firstname|owner_email=root@localhost|auto_approve=true"}) 

request_hash = response.to_hash
puts "Request Returned: #{request_hash.inspect}"
puts "Automation Request Id: #{request_hash[:create_automation_request_response][:return].inspect}"

#      output = AddHashToArray(response_hash[:item])
#      output.each { |key| puts "ID: #{key[:id]}\t Name: #{key[:name]}" }
  end
end
