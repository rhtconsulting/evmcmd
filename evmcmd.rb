#!/usr/bin/env ruby
#####################################################################################
# Copyright 2014 Jose Simonelli <jose@redhat.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
#####################################################################################
#
# Contact Info: <jose@redhat.com> and <lester@redhat.com>
#
#####################################################################################

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
    if cmdargs.count == 1
      cmd.merge!(:args => false)
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
