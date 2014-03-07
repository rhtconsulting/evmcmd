#!/usr/bin/env ruby

require 'yaml'

def read_config
    begin
      return YAML.load_file("config.yaml")
    rescue => exception
      puts exception.message
    end
end

config = read_config

install_path = config["application"]["instpath"]

load "#{install_path}evmcmd.rb"

# Create a new instance of the class EvmCmd.  No parameters to pass.
class RunCmd
  def self.int(vars)
    myCmd = EvmCmd.new
    output = myCmd.run(vars)
  end
  def self.run(cmdargs)
      myCmd = EvmCmd.new
        arguments = ""
        cmdargs.each do |a|
          arguments += "#{a} "
        end
        myCmd.run(arguments.to_s)
  end
end

RunCmd.run(ARGV)