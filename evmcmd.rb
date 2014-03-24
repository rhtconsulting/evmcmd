#!/usr/bin/env ruby
require 'yaml'
require 'optparse'

def read_config
    begin
      return YAML.load_file("config.yaml")
    rescue => exception
      puts exception.message
    end
end

config = read_config

install_path = config["application"]["instpath"]

load "#{install_path}evmcmd_class.rb"

# Create a new instance of the class EvmCmd.  No parameters to pass.
class RunCmd
  def self.int(vars)
    myCmd = EvmCmd.new
    output = myCmd.run(vars)
  end
  def self.run(cmdargs)
    myCmd = EvmCmd.new
    cmd = {'-x'=>"#{cmdargs[0]}"}
    puts cmd.inspect
    if cmdargs.count == 1
      puts cmdargs.count.inspect
      cmd.merge!(:args => false)
      puts cmd.inspect
      myCmd.run(cmd)
    else
      cmdargs.delete(cmdargs[0])
      arguments = Hash[*cmdargs.flatten]
      cmd.merge!(:args => true)
      cmd.merge!(arguments)
      myCmd.run(cmd)
    end
  end
end

RunCmd.run(ARGV)
