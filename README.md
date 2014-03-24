EVMCMD Interface
----------------
The evmcmd is a command line interface to the CFME webservice interface.  It is intended to be used to retrieve information from the CFME engine and test that  the CFME engine is up and running.

Requirements
------------
Ruby 2.0 or higher
Savon 2.0 or higher

Usage
-----
evmcmd host_listall    
evmcmd host_gettags 29344dcc-3b54-11e3-97a2-005056b367d4    
evmcmd vm_listall    
evmcmd vm_gettags 2a4765fa-3b54-11e3-97a2-005056b367d4    
evmcmd vm_details 2a4765fa-3b54-11e3-97a2-005056b367d4    
evmcmd cluster_listall    
evmcmd resourcepool_listall    
evmcmd datastore_listall    
evmcmd version    

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
