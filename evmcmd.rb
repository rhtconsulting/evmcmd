#!/usr/bin/env ruby
$INSTALL_PATH="/Users/lesterclaudio/work/ruby-project/evmcmd"

load "lib/CFMEConnection.rb"
load "lib/management_systems.rb"
load "lib/virtual_machines.rb"
load "lib/hosts.rb"
load "lib/clusters.rb"
load "lib/datastores.rb"
load "lib/resource_pools.rb"

require 'readline'
require 'savon'
require 'rubygems'
require 'yaml'

#TODO: Savon 2.0 went away from this object .. we need to figure out how to configure things the new way.
#Savon.configure do |config|
#  config.log = false
#  config.pretty_print_xml = true
#  config.log_level = :info
#  config.raise_errors = false
#  HTTPI.log = false
#end


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
        'mgtsys_listall',
        'mgtsys_gettags',
        'mgtsys_details',
        'host_listall',
        'host_gettags',
        'host_getvms',
        'vm_listall',
        'vm_gettags',
        'vm_details',
        'cluster_listall',
        'resourcepool_listall',
        'datastore_listall',
        'version',
        'help',
        'exit',
        'quit'].sort
    @list = [
        ['mgtsys_listall', 'List All managed systems in the CFME Appliance'],
        ['mgtsys_gettags', 'Get all the tags that are defined in the CFME Appliance'],
        ['mgtsys_details', 'Get all the details from the CFME Appliance'],
        ['host_listall', 'List all the hosts in the CFME Appliance'],
        ['host_gettags', 'Get all the tags defined for a specific host in the CFME Appliance'],
        ['host_getvms', 'Get all the VMs that are managed by the CFME Appliance'],
        ['vm_listall', 'List all the Virtual Machines managed by the CFME Appliance'],
        ['vm_gettags', 'Get all the tags for a Virtual Machine'],
        ['vm_details', 'Retrieve the Virtual Machine details'],
        ['cluster_listall', 'List all the Clusters managed by the CFME Appliance'],
        ['resourcepool_listall', 'List all the resource pools managed by the CFME Appliance'],
        ['datastore_listall', 'List all the Datastores managed by the CFME Appliance'],
        ['version', 'Get the CFME Appliance Version'],
        ['help [cmd]', 'Help me please!'],
        ['exit', 'Get me out of here!'],
        ['quit', 'Get me out of here!']
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
          run_method = run_cmd.shift
          run_arguments = run_cmd.shift
          handle_call(run_method, run_arguments)
        end
      else
        run_cmd = arguments.split
        run_method = run_cmd.shift
        run_arguments = run_cmd.shift
        puts "Running command #{run_method} arguments: #{run_arguments}"
        handle_call(run_method, run_arguments)
      end
    rescue => exception
      puts exception.message
      puts "Returning to the prompt."
      run(arguments)
    end
  end

  def handle_call( run_method, run_arguments)
    begin
      case run_method
        when "quit", "QUIT"
          self.quit
        when "exit", "EXIT"
          self.exit
        when "version"
          self.version
        when "mgtsys_listall"
          @management_sytems.listall
        when "mgtsys_details"
          @management_sytems.details(run_arguments)
        when "mgtsys_gettags"
          @management_sytems.gettags(run_arguments)
        when "datastore_listall"
          @datastore.listall
        when "resourcepool_listall"
          @resourcepool.listall
        when "vm_listall"
          @virtualmachines.listall
        when "vm_gettags"
          @virtualmachines.gettags(run_arguments)
        when "host_listall"
          @host.listall
        when "host_getvms"
          @host.getvms(run_arguments)
        when "host_gettags"
          @host.gettags(run_arguments)
        when "cluster_listall"
          @cluster.listall
        when "evm_get"
          puts @client.call(:evm_get, message: {token: "help"})
        when "evm_ping"
          puts @client.call(:evm_ping, nil)
        when "test"
          @evm_commands.each do |cmd|
            begin
              puts "Executing Command: #{cmd}"
              @client.call(cmd)
            rescue => exception
              puts "Exception " << exception.message
            end
          end
        when "event_list"
          @client.call(:evm_event_list)
        when "details"
          if run_arguments != nil
            @management_sytems.managementsystem_details(run_arguments)
          else
            puts self.help("managementsystem_details")
          end
        when "gettags"
          @management_sytems.gettags(run_arguments)
        when "help"
          if (run_arguments == nil)
            self.help(nil)
          else 
            self.help(run_arguments)
          end
        else
          puts "Unrecognized command"
          self.help(nil)
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



