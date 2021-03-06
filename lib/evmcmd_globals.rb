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

# Revision
$version = "0.000001 alpha"

# Command Prompt
#$cmdprompt = "evmcmd>"


########################################################################################################################
def showminimal(id_title, id_value, name_title, name_value)
  puts "#{id_title}: #{id_value}\t #{name_title}: #{name_value}"
end


########################################################################################################################
def splitOpts(*args)
  # Method to be able to split apart the arguments passed from the CLI or Shell to make them into a hash from the data
  # sent as key=value on the CLI or Shell, this will give you {key=>"value"} for each of the arguments passed.
  $i = 0
  out_hash = {}
  arr = args[0]
  total_var = arr.count
  while $i < total_var do
    tmp_hash = {}
    tmp_a = arr.to_a.slice($i).split(/=/)
    tmp_hash = Hash[*tmp_a.flatten]
    merged_hash = out_hash.merge!(tmp_hash)
    $i +=1
  end
  $i = 0
  return merged_hash
end

########################################################################################################################
def AddHashToArray(obj)
  # this is used as a workaround to a bug (or needed feature enhancement) due to the result command back as a hash
  # when the result only includes one system or object, anything above 1 object it then wraps it in an array of hashes
  # this was built just so that all the code outside of this can just easily check what class type it is and wrap it i
  # needed
  case obj
    when Array
      return obj
    when Hash
      tmp_a = []
      tmp_a << Hash[*obj.flatten]
      return tmp_a
  end
end

########################################################################################################################
def extractHashes(array)
  # method to be able to extract data from nested array of hashes inside an array...
  newhash = {}
  array.each {|name,value| newhash[:"#{name[:name]}"] = "#{name[:value]}" }
  return newhash
end