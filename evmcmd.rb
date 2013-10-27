#!/usr/bin/env ruby

load './lib/evmcmd_globals.rb'
require 'optparse'
require 'ostruct'
require 'strscan'
require 'readline'
require 'savon'

Savon.configure do |config|
  config.log = false
  config.pretty_print_xml = true
  config.log_level = :info
  config.raise_errors = false
  HTTPI.log = false
end

def help
puts "#  This is a work in progress, only have commands to allow to query cloudforms without options being passed at this time
#  You are able to tab complete each command if needed

\t Commands that can currently be run:
\t\t get_allmanagementsystems
\t\t get_allhosts
\t\t get_allvms
\t\t get_allclusters
\t\t get_allresourcepools
\t\t get_alldatastores
\t\t help
\t\t exit
"
end

puts "##############################################################################
#  Version: #{$version}"
help

LIST = [
  'get_allmanagementsystems',
  'get_allhosts',
  'get_allvms',
  'get_allclusters',
  'get_allresourcepools',
  'get_alldatastores',
  'help',
  'exit'
].sort

comp = proc { |s| LIST.grep(/^#{Regexp.escape(s)}/) }

Readline.completion_append_character = ""
Readline.completion_proc = comp

while line = Readline.readline("#{$cmdprompt}", true)
  send(line)
end


