#!/usr/bin/env ruby

$INSTALL_PATH="/Users/lesterclaudio/work/ruby-project/evmcmd"

load "#{$INSTALL_PATH}/evmcmd.rb"

# Create a new instance of the class EvmCmd.  No parameters to pass.
myCmd = EvmCmd.new

arguments = ""
ARGV.each do |a|
  arguments = "#{a} "
end

myCmd.run(arguments)
