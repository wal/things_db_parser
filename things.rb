require 'rexml/document'
require 'rexml/xpath'

if ARGV.size < 1
  puts "Usage: ruby things.rb PROJECT_NAME" 
  exit
end

PROJECT_NAME = ARGV[0]                                                                                    
DATABASE = ARGV[1] || "#{ENV['HOME']}/Library/Application Support/Cultured Code/Things/database.xml"

file = File.new(DATABASE)
doc = REXML::Document.new file
         
project =  REXML::XPath.first(doc, "/database/object[@type='TODO' and attribute='#{PROJECT_NAME}']")
    
def state(status)
  case status
  when 0
    "Open"    
  when 3
    "Complete"
  else
    "Unknown state #{status}"
  end
end

if project                                 
  puts "Project - #{PROJECT_NAME}\n--"
  children = project.elements["relationship[@name='children']"].attributes["idrefs"].split(' ')
  children.each do |child|
    child = REXML::XPath.first(doc, "/database/object[@type='TODO' and @id='#{child}']")
    task_name = child.elements["attribute[@name='title']"].text
    task_state = state(child.elements["attribute[@name='status']"].text.to_i)
    puts "#{task_state} : #{task_name}"
  end                                
else
  puts "no project with that name : #{PROJECT_NAME}"
end

