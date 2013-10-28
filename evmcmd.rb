#!/usr/bin/env ruby
$INSTALL_PATH="/opt/evmcmd"

load 'lib/evmcmd_globals.rb'
require 'optparse'
require 'ostruct'
require 'strscan'
require 'readline'
require 'savon'

Savon.configure do |config|
#  config.log = false
  config.pretty_print_xml = true
#  config.log_level = :info
#  config.raise_errors = false
#  HTTPI.log = false
end

def help
puts "#  This is a work in progress, only have commands to allow to query cloudforms without options being passed at this time
#  You are able to tab complete each command if needed

\t Commands that can currently be run:
\t\tmanagementsystem_listall
\t\thost_listall
\t\tvirtualmachine_listall
\t\tcluster_listall
\t\tresourcepool_listall
\t\tdatastore_listall
\t\tems_version
\t\thelp
\t\texit
"
end

puts "##############################################################################
#  Version: #{$version}"
help

LIST = [
  'managementsystem_listall',
  'host_listall',
  'host_getvms',
  'virtualmachine_listall',
  'cluster_listall',
  'resourcepool_listall',
  'datastore_listall',
  'ems_version',
  'help',
  'exit'
].sort

comp = proc { |s| LIST.grep(/^#{Regexp.escape(s)}/) }

Readline.completion_append_character = ""
Readline.completion_proc = comp

while line = Readline.readline("#{$cmdprompt}", true)
  send(line)
end


