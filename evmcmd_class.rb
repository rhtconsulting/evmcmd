#!/usr/bin/env ruby

load "lib/CFMEConnection.rb"
load "lib/management_systems.rb"
load "lib/virtual_machines.rb"
load "lib/automationreq.rb"
load "lib/hosts.rb"
load "lib/clusters.rb"
load "lib/datastores.rb"
load "lib/resource_pools.rb"

require 'readline'
require 'savon'
require 'rubygems'
require 'yaml'

class EvmCmd  
  def initialize   
    # Instance variables
    # TODO: Need to see if there are other instance variables for this class.  
    # Command Prompt
    @evm_commands = [:evm_get, :evm_set, :evm_ping, 
      :evm_vm_list, :evm_host_list, :evm_cluster_list, 
      :evm_resource_pool_list, :evm_datastore_list, :evm_vm_software, 
      :evm_vm_accounts, :evm_get_host, :evm_get_hosts, :evm_get_cluster, 
      :evm_get_clusters, :evm_get_resource_pool, 
      :evm_get_resource_pools, :evm_get_datastore, :evm_get_datastores, 
      :evm_get_vm, :evm_get_vms, :evm_delete_vm_by_name, :evm_smart_start, 
      :evm_smart_stop, :evm_smart_suspend, :evm_get_policy, :evm_event_list, 
      :evm_condition_list, :evm_action_list, :evm_policy_list, :evm_vm_rsop, 
      :evm_assign_policy, :evm_unassign_policy, :evm_add_lifecycle_event, 
      :evm_provision_request, :evm_provision_request_ex, :evm_host_provision_request, 
      :evm_vm_scan_by_property, :evm_vm_event_by_property, :get_ems_list, 
      :get_host_list, :get_cluster_list, :get_resource_pool_list, :get_datastore_list, 
      :get_vm_list, :find_ems_by_guid, :find_hosts_by_guid, :find_host_by_guid, :find_clusters_by_id,
      :findvms_bytag, :automationreq_create,
      :find_cluster_by_id, :find_datastores_by_id, :find_datastore_by_id, :find_resource_pools_by_id,
      :find_resource_pool_by_id, :find_vms_by_guid, :find_vm_by_guid, :get_ems_by_list, :get_hosts_by_list,
      :get_clusters_by_list, :get_datastores_by_list, :get_resource_pools_by_list, :get_vms_by_list, 
      :get_vms_by_tag, :get_templates_by_tag, :get_clusters_by_tag, :get_resource_pools_by_tag, :get_datastores_by_tag, 
      :vm_add_custom_attribute_by_fields, :vm_add_custom_attribute, :vm_add_custom_attributes, :vm_delete_custom_attribute, 
      :vm_delete_custom_attributes, :version, :vm_provision_request, :vm_set_owner, :vm_set_tag, :vm_get_tags, :host_set_tag, 
      :host_get_tags, :cluster_set_tag, :cluster_get_tags, :ems_set_tag, :ems_get_tags, :datastore_set_tag, :datastore_get_tags, 
      :resource_pool_set_tag, :resource_pool_get_tags, :get_vm_provision_request, :get_vm_provision_task, :create_automation_request, 
      :get_automation_request, :get_automation_task, :vm_invoke_tasks]
    @cmdprompt = "evmcmd>"

    @command = nil 
    @LIST = [
        'automationreq_create',
        'mgtsys_listall',
        'mgtsys_gettags',
        'mgtsys_details',
        'host_listall',
        'host_gettags',
        'host_getvms',
        'host_details',
        'vm_listall',
        'vm_gettags',
        'vm_details',
        'vm_bytag',
        'vm_settag',
        'cluster_listall',
        'cluster_getvms',
        'cluster_gethosts',
        'cluster_getmgtsys',
        'cluster_bytag',
        'resourcepool_listall',
        'datastore_listall',
        'datastore_getvms',
        'datastore_gethosts',
        'datastore_getmgtsys',
        'datastore_bytag',
        'version',
        'evm_ping',
        'evm_host_list',
        'evm_resource_pool_list',
        'help',
        'exit',
        'quit'].sort
    @list = [
        ['automationreq_create', 'Create Automation Request'],
        ['provisionrequest', 'Create VM Provisioning Request'],
        ['mgtsys_listall', 'List All managed systems in the CFME Appliance'],
        ['mgtsys_gettags', 'Get all the tags that are defined in the CFME Appliance'],
        ['mgtsys_settag', 'Set all the tags for the CFME Appliance'],
        ['mgtsys_details', 'Get all the details from the CFME Appliance'],
        ['host_listall', 'List all the hosts in the CFME Appliance'],
        ['host_gettags', 'Get all the tags defined for a specific host in the CFME Appliance'],
        ['host_settags', 'set all the tags defined for a specific host in the CFME Appliance'],
        ['host_getvms', 'Get all the VMs that are managed by the CFME Appliance'],
        ['host_getmgtsys', 'Get all the VMs that are managed by the CFME Appliance'],
        ['host_details', 'Get host details'],
        ['vm_listall', 'List all the VMs managed by the CFME Appliance'],
        ['vm_details', 'VM details'],
        ['vm_settag', 'Set tag for VM'],
        ['vm_gettags', 'List all tags in VM'],
        ['vm_list_bytag', 'List all the VMs by tag'],
        ['cluster_listall', 'List all the Clusters managed by the CFME Appliance'],
        ['cluster_getvms', 'List all VM in the Datastore'],
        ['cluster_gethosts', 'List all Hosts connected to the Datastore'],
        ['cluster_getmgtsys', 'List the mgmt systems for the Datastore'],
        ['cluster_settag', 'List all the Clusters by tag'],
        ['cluster_gettags', 'List all the Clusters by tag'],
        ['cluster_list_bytag', 'List all the Clusters by tag'],
        ['resourcepool_listall', 'List all the resource pools managed by the CFME Appliance'],
        ['datastore_listall', 'List all the Datastores managed by the CFME Appliance'],
        ['datastore_getvms', 'List all VM in the Datastore'],
        ['datastore_gethosts', 'List all Hosts connected to the Datastore'],
        ['datastore_getmgtsys', 'List the mgmt systems for the Datastore'],
        ['datastore_settag', 'List all the Datastores by tag'],
        ['datastore_gettags', 'List all the Datastores by tag'],
        ['datastore_list_bytag', 'List all the Datastores by tag'],
        ['version', 'Get the CFME Appliance Version'],
        ['evm_ping', 'Ping the CFME Appliance'],
        ['help [cmd]', 'Help me please!'],
        ['exit', 'Get me out of here!'],
        ['quit', 'I want to quit! Get me out of here!']
      ].sort
    
    config = self.read_config
    # Instance variables for objects that we will be using ... probably needs refactoring after this...
    
    @cfmehost = config["connection"]["host"] 
    if config["connection"]["port"] != nil
      @cfmehost = @cfmehost << ":" << config["connection"]["port"]
    end
    @cfmeuser = config["connection"]["user"]
    @cfmepass = config["connection"]["pass"]
    @cmdprompt = config["application"]["prompt"]
    @client = CFMEConnection.instance
    @client.login(@cfmehost, @cfmeuser, @cfmepass)
    @management_sytems = ManagementSystems.new
    @virtualmachines = VirtualMachines.new
    @host = Host.new
    @automationreq = AutomationRequest.new
    @cluster = Clusters.new
    @datastore = DataStore.new
    @resourcepool = ResourcePool.new
  end

  def read_config
    begin
      return YAML.load_file("config.yaml")
    rescue => exception
      puts exception.message
    end
  end

  ########################################################################################################################
  def help ( cmd )
    if cmd == nil
      puts "#  This is a work in progress, only have commands to allow to query cloudforms without options being passed at this time
      #  You are able to tab complete each command if needed
      \t Commands that can currently be run: "

      # Let's just go through the list that we have ...
      @list.each do | citem, msg |
        puts "  " << citem
      end
    else
      @list.each do | citem, msg |
        if citem == cmd 
          if citem != nil
            command = citem
            message = msg
            puts "#{command} : #{message}"
            break
          end
        end
      end
    end
  end
  
  def version
    puts @client.ems_version
  end

  def run (arguments)
    begin
      comp = proc { |s| @LIST.grep(/^#{Regexp.escape(s)}/) }

      Readline.completion_append_character = ""
      Readline.completion_proc = comp

      if (ARGV[0].nil?) then
        while line = Readline.readline("#{@cmdprompt} ", true)
          run_cmd = line.split
          cmd = {'-x'=>"#{run_cmd[0]}"}
          run_cmd.delete(run_cmd[0])
          run_args = Hash[*run_cmd.flatten]
          run_method = cmd['-x']
          run_arguments = run_args
#         puts "Running command #{run_method} arguments: #{run_arguments}"
          handle_call(cmd['-x'], run_args)
        end
      else
        run_cmd = arguments['-x']
        run_method = arguments['-x']
        run_arguments = arguments
#        puts "Running command #{run_method} arguments: #{run_arguments}"
        handle_call(arguments['-x'], run_arguments)
      end
    rescue => exception
      puts exception.message
      puts "Returning to the prompt."
      run(arguments)
    end
  end

  def handle_call(run_method, run_arguments)
    begin
      case run_method
        when "quit", "QUIT"
          self.quit
        when "exit", "EXIT"
          self.exit
        when "version"
          self.version
        when "mgtsys_listall"
          @management_sytems.listall(run_arguments)
        when "mgtsys_details"
          @management_sytems.details(run_arguments)
        when "mgtsys_gettags"
          @management_sytems.gettags(run_arguments)
        when "mgtsys_settag"
          @management_sytems.settag(run_arguments)
        when "evm_ping"
          @management_sytems.ping(run_arguments)
        when "mgtsys_host_list"
          @management_sytems.host_list(run_arguments)
        when "datastore_listall"
          @datastore.listall(run_arguments)
        when "datastore_getvms"
          @datastore.getvms(run_arguments)
        when "datastore_gettags"
          @datastore.gettags(run_arguments)
        when "datastore_settag"
          @datastore.settag(run_arguments)
        when "datastore_list_bytag"
          @datastore.bytag(run_arguments)
        when "datastore_gethosts"
          @datastore.gethosts(run_arguments)
        when "datastore_getmgtsys"
          @datastore.getmgtsys(run_arguments)
        when "resourcepool_gettags"
          @resourcepool.gettags(run_arguments)
        when "resourcepool_settag"
          @resourcepool.settag(run_arguments)
        when "resourcepool_listall"
          @resourcepool.listall(run_arguments)
        when "resourcepool_getvms"
          @resourcepool.getvms(run_arguments)
        when "resourcepool_gethosts"
          @resourcepool.gethosts(run_arguments)
        when "resourcepool_list_bytag"
          @resourcepool.bytag(run_arguments)
        when "resourcepool_getmgtsys"
          @resourcepool.getmgtsys(run_arguments)
        when "vm_listall"
          @virtualmachines.listall(run_arguments)
        when "vm_details"
          @virtualmachines.details(run_arguments)
        when "vm_setowner"
          @virtualmachines.setowner(run_arguments)
        when "vm_settag"
          @virtualmachines.settag(run_arguments)
        when "vm_gettags"
          @virtualmachines.gettags(run_arguments)
        when "vm_state_start"
          @virtualmachines.state_start(run_arguments)
        when "vm_state_stop"
          @virtualmachines.state_stop(run_arguments)
        when "vm_state_suspend"
          @virtualmachines.state_suspen(run_arguments)
        when "vm_list_bytag"
          @virtualmachines.bytag(run_arguments)
        when "vm_delete"
          @virtualmachines.vmrm(run_arguments)
        when "host_listall"
          @host.listall(run_arguments)
        when "host_gettags"
          @host.gettags(run_arguments)
        when "host_settag"
          @host.settag(run_arguments)
        when "host_getvms"
          @host.getvms(run_arguments)
        when "host_details"
          @host.details(run_arguments)
        when "host_getmgtsys"
          @host.getmgtsys(run_arguments)
        when "create_automation_request"
          @automationreq.create_automation_request(run_arguments)
        when "provision_request"
          @automationreq.provision(run_arguments)
        when "get_automation_request"
          @automationreq.get_automation_request(run_arguments)
        when "get_automation_task"
          @automationreq.get_automation_task(run_arguments)
        when "cluster_listall"
          @cluster.listall(run_arguments)
        when "cluster_getvms"
          @cluster.getvms(run_arguments)
        when "cluster_gettags"
          @cluster.gettags(run_arguments)
        when "cluster_settag"
          @cluster.settag(run_arguments)
        when "cluster_list_bytag"
          @cluster.bytag(run_arguments)
        when "cluster_gethosts"
          @cluster.gethosts(run_arguments)
        when "cluster_getmgtsys"
          @cluster.getmgtsys(run_arguments)
        when "create_instance"
          @automationreq.create_instance(run_arguments)
        when "test"
          @evm_commands.each do |cmd|
            begin
              puts "Executing Command: #{cmd}"
              puts @client.call(cmd, nil)
            rescue => exception
              puts "Exception " << exception.message
            end
          end
        when "event_list"
          @client.call(:evm_event_list, nil)
        when "help"
          if (run_arguments == nil)
            self.help(nil)
          else 
            self.help(run_arguments)
          end
        else
          puts "Unrecognized command: #{run_method}"
          self.help({})
        end
    rescue => exception
      puts "Exception: " << exception.message
      return
    end
  end

  ########################################################################################################################
  def quit
    puts "Quitter!"
    Process.exit!(true)
  end

  ########################################################################################################################
  def exit
    puts "Goodbye!"
    Process.exit!(true)
  end

  ########################################################################################################################
  def showminimal(id_title, id_value, name_title, name_value)
    puts "#{id_title}: #{id_value}\t #{name_title}: #{name_value}"
  end


  ########################################################################################################################
  def parseCli(run_method, run_args)
    unless run_method == "blank"
      send (run_method)
    end
  end
end



