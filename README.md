EVMCMD Interface
----------------
The evmcmd is a command line interface to the CFME webservice interface.  It is intended to be used to retrieve information from the CFME engine and test that  the CFME engine is up and running.

Requirements
------------
Ruby 2.0 or higher
Savon 2.0 or higher

Usage
-----
./evmcmd.rb help
./evmcmd.rb evm_ping

./evmcmd.rb mgtsys_listall
./evmcmd.rb mgtsys_details -g <guid>
./evmcmd.rb mgtsys_gettags -g <guid>
./evmcmd.rb mgtsys_settag -g <guid> -c cc -n 002
./evmcmd.rb mgtsys_host_list

./evmcmd.rb host_listall
./evmcmd.rb host_gettags -g <guid>
./evmcmd.rb host_settag -g <guid>-c cc -n 002
./evmcmd.rb host_getvms -g <guid>
./evmcmd.rb host_getmgtsys -g <guid>
./evmcmd.rb host_details -g <guid>

./evmcmd.rb datastore_listall
./evmcmd.rb datastore_getvms -i <id>
./evmcmd.rb datastore_gethosts -i <id>
./evmcmd.rb datastore_gettags -i <id>
./evmcmd.rb datastore_settag -i <id> -c cc -n 002
./evmcmd.rb datastore_getmgtsys -i <id>
./evmcmd.rb datastore_gettags -i <id>
./evmcmd.rb datastore_list_bytag -t storagetype/replicated

./evmcmd.rb cluster_listall
./evmcmd.rb cluster_getvms -i <id>
./evmcmd.rb cluster_gettags -i <id>
./evmcmd.rb cluster_settag -i <id> -c cc -n 002
./evmcmd.rb cluster_gethosts -i <id>
./evmcmd.rb cluster_getmgtsys -i <id>
./evmcmd.rb cluster_list_bytag -t location/ny

./evmcmd.rb resourcepool_listall
./evmcmd.rb resourcepool_gettags -i <id>
./evmcmd.rb resourcepool_getmgtsys -i <id>
./evmcmd.rb resourcepool_settag -i <id> -c cc -n 001
./evmcmd.rb resourcepool_settag -i <id> -c location -n ny
./evmcmd.rb resourcepool_list_bytag -t location/ny
./evmcmd.rb resourcepool_list_bytag -t cc/001

./evmcmd.rb vm_listall
./evmcmd.rb vm_details -g <guid>
./evmcmd.rb vm_gettags -g <guid>
./evmcmd.rb vm_settag -g <guid> -c cc -n 002
./evmcmd.rb vm_list_bytag -t location/chicago
./evmcmd.rb vm_list_bytag -t location/ny
./evmcmd.rb vm_list_bytag -t cc/002 --out json

./evmcmd.rb vm_state_start -g <guid>
./evmcmd.rb vm_state_stop -g <guid>
./evmcmd.rb vm_state_suspend -g <guid>

./evmcmd.rb get_automation_request -i <id>
./evmcmd.rb get_automation_task -i <id>
./evmcmd.rb provision_request -t <templateFields> -v <vmFields> -r <requester> -c <tags> -V <values> -E <ems_custom_attributes> -M <miq_custom_attributes>
./evmcmd.rb automation_request -u <uri_parts> -p <parameters> -r <requester>



Or alternatively by running the evmcmd itself to bring up the prompt to the run the same tests above but without evmcmd
in from

evmcmd> mgtsys_listall    
evmcmd> mgtsys_gettags 02f0f85e-3b54-11e3-bce6-005056b367d4    
evmcmd> mgtsys_settags 02f0f85e-3b54-11e3-bce6-005056b367d4 department accounting    
evmcmd> mgtsys_details 02f0f85e-3b54-11e3-bce6-005056b367d4    
evmcmd> cluster_listall    
evmcmd> host_listall    
evmcmd> host_gettags 29344dcc-3b54-11e3-97a2-005056b367d4    
evmcmd> vm_listall    
evmcmd> vm_gettags vmGuid=2a4765fa-3b54-11e3-97a2-005056b367d4    
evmcmd> vm_details vmGuid=2a4765fa-3b54-11e3-97a2-005056b367d4    
evmcmd> cluster_listall    
evmcmd> resourcepool_listall    
evmcmd> datastore_listall    
evmcmd> version    

Current Updates
---------------
The current version has been updated to use OO constructs.  We have defined the following classes:

* Class EvmCmd - Main class for the EVMCMD application
* Class Hosts  - Class that handles all requests for host information
* Class CFMEConnection - Connection singleton class that handles the calls to the Web Service
* Class VirtualMachines - Class that handles requests for the vm information.
* Class ManagementSystems - Class that handles requests for the systems managed by the CFME engine.
* Class Clusters - Class that handles the requests for cluster information.

More commands to come as I translate what I see from the WSDL and how to convert it within the framework I started with.

Any comments are welcome

jose@redhat.com
lester@redhat.com
