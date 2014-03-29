#!/usr/bin/env ruby

class AutomationRequest
  def initialize
    @client = CFMEConnection.instance
  end

  ########################################################################################################################
  def provision(args)
    $template = args['-t']
    $vm = args['-v']
    $requester = args['-r']
    $tags = args['-c']
    $values = args['-V']
    $miq_values = args['-M']
    $ems_values = args['-E']

    body_hash = {}
    body_hash['version']            = '1.1'
    body_hash['templateFields'] = "#{$template}"
    body_hash['vmFields']           = "#{$vm}"
    body_hash['requester']          = "#{$requester}"
    body_hash['tags']                       = "#{$tags}"
    body_hash['options']            = { 'values' => "#{$values}", 'miq_custom_attributes' => "#{$miq_values}", 'ems_custom_attributes' => "#{$ems_values}" }

    response = @client.call(:vm_provision_request, message: body_hash)
    request_hash = response.to_hash

    if args['--out'] == nil
      puts "Request Returned: #{request_hash.inspect}"
      puts "Provision Request Id: #{request_hash[:vm_provision_request_response][:return].inspect}"
    end

    if args['--out'] == 'json'
      puts JSON.pretty_generate(request_hash[:vm_provision_request_response][:return])
    end

  end

  ########################################################################################################################
  def create_automation_request(args)
    $uri_parts = args['-u']
    $parameters = args['-p']
    $requester = args['-r']

    body_hash = {}
    body_hash['version']            = '1.1'
    body_hash['uri_parts']          = "#{$template}"
    body_hash['parameters']         = "#{$parameters}"
    body_hash['requester']          = "#{$requester}"

    response = @client.call(:create_automation_request, message: body_hash)
    request_hash = response.to_hash

    if args['--out'] == nil
      puts "Request Returned: #{request_hash.inspect}"
      puts "Provision Request Id: #{request_hash[:vm_provision_request_response][:return].inspect}"
    end

    if args['--out'] == 'json'
      puts JSON.pretty_generate(request_hash[:vm_provision_request_response][:return])
    end

  end

  ########################################################################################################################
  def get_automation_task(args)
    $id = args['-i']
    response = @client.call(:get_automation_task, message: {taskId: "#{$id}"})
    request_hash = response.to_hash

    if args['--out'] == nil
      puts "Request Returned: #{request_hash.inspect}"
      puts "Provision Request Id: #{request_hash[:get_automation_task_response][:return].inspect}"
    end

    if args['--out'] == 'json'
      puts JSON.pretty_generate(request_hash[:get_automation_task_response][:return])
    end

  end

  ########################################################################################################################
  def get_automation_request(args)
    $id = args['-i']
    response = @client.call(:get_automation_request, message: {requestId: "#{$id}"})
    request_hash = response.to_hash

    if args['--out'] == nil

      puts "Request Returned: #{request_hash.inspect}"
      puts "Provision Request Id: #{request_hash[:get_automation_request_response][:return].inspect}"
    end

    if args['--out'] == 'json'
      puts JSON.pretty_generate(request_hash[:get_automation_request_response][:return])
    end

  end

  ########################################################################################################################
  def create_instance(args)
    $namespace = args['-n']
    $class = args['-c']
    $instance = args['-i']
    $value = args['-v']

    body_hash = {}
    body_hash['version']            = '1.1'
    body_hash['uri_parts']          = "namespace=evmcmd/Factory|class=Instances|instance=CreateInstance|message=create"
    body_hash['parameters']         = "namespace=#{$namespace}|class=#{$class}|instance=#{$instance}|value=#{$value}"
    body_hash['requester']          = "user_name=admin|owner_last_name=Lastname|owner_first_name=Firstname|owner_email=root@localhost|auto_approve=true"

    response = @client.call(:create_automation_request, message: body_hash)
    request_hash = response.to_hash
    puts "Request Returned: #{request_hash.inspect}"

  end

  ########################################################################################################################
  def export_chargeback_prices(args)
    body_hash = {}
    body_hash['version']            = '1.1'
    body_hash['uri_parts']          = "namespace=evmcmd|class=RailsRunner|instance=ChargebackExport|message=create"
    body_hash['parameters']         = "send_stdout=true"
    body_hash['requester']          = "user_name=admin|owner_last_name=Lastname|owner_first_name=Firstname|owner_email=root@localhost|auto_approve=true"

    response = @client.call(:create_automation_request, message: body_hash)
    request_hash = response.to_hash


    if args['--out'] == nil
      puts "Request Returned: #{request_hash.inspect}"
    end

    if args['--out'] == 'json'
      puts JSON.pretty_generate(response_hash)
    end
  end

end
