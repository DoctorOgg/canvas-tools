#!/usr/bin/env ruby
require 'rubygems'
require 'getoptlong'
require 'colorize'
require 'json'
require 'fileutils'
require 'rest-client'
require 'csv'
require 'console_table'


@config_file = "#{ENV["HOME"]}/.canvas-tools.json"
@active_config = ""
@file = ""

def generate_example_config
  example_config = {
    :learnistute => {
      :url => "https://lms.someschool.org",
      :token => "PLACE YOUR ADMIN TOKEN HERE.",
      :account_id => 1
    }
  }
  if !File.exists? @config_file
    puts "Config file not found".colorize(:red)
    puts "Generating example config: #{@config_file}".colorize(:yellow)
    File.open(@config_file,"w") do |f|
      f.write(JSON.pretty_generate(example_config))
    end
  end
end

def load_config
  if File.exists? @config_file
    puts "Found config file: #{@config_file}"
    begin
      @config = JSON.parse(File.read @config_file)
    rescue
      puts "I'm So Sorry, I can't open or read or find your config file (#{@config_file})".colorize(:red)
      exit 1
    end
  end
end

def generate_example_csv
  filename = "canvas-addusers-example.csv"
  example_data = [
    ["Name","e-mail","SIS_ID"],
    ["Fake3 middle Student","Fake3@example.com","4043.6"],
    ["Fake2 Student-dash","Fake2@example.com","4044.6"],
    ["Fake1 Student","Fake1@example.com","4042.6"]
  ]
  if File.exists? filename
    puts "I have already created an example, if you want to repeat this, try renameing the file".colorize(:red)
  else
    puts "Generating example csv: #{filename}".colorize(:yellow)
    s = File.open(filename,"w")
    csv = CSV.new(s, :force_quotes => true)
    example_data.each do |row|
      csv << row
    end
    s.close
  end

end

def display_help
	puts
  puts "This tool is used to add users to your canvas install using an CSV file"
  puts "Config File: #{@config_file.colorize(:blue)}"
  puts
	puts "Options:"
	puts "-h or --help ".ljust(30) 		  	+"-> Display this help message"
	puts "-c or --config".ljust(30) 		  +"-> Specifiy Config to use"
	puts "-f or --file".ljust(30) 		    +"-> CSV File"
	puts "-l or --list".ljust(30)         + "-> List Valid Configs"
  puts "-g or --generate".ljust(30)     + "-> Generate an example csv file"
	puts
	exit 1
end

def parse_cli
  if ARGV[0] == nil
  	display_help
  end

  parser = GetoptLong.new
  parser.set_options(["-h", "--help", GetoptLong::NO_ARGUMENT],
                     ["-c", "--config", GetoptLong::NO_ARGUMENT],
                     ["-f", "--fqdn", GetoptLong::NO_ARGUMENT],
                     ["-l", "--list", GetoptLong::NO_ARGUMENT],
                     ["-g", "--generate", GetoptLong::NO_ARGUMENT]

                     )

  begin
    begin
        opt,arg = parser.get_option
        break if not opt
        case opt
           when "-h" || "--help"
             display_help
           exit
           when "-c" || "--config"
              @active_config = ARGV[0].strip().downcase()
           when "-f" || "--file"
              @file = ARGV[0].strip()
           when "-l" || "--list"
              list
          when "-g" || "--generate"
              generate_example_csv
  	    end
    rescue => err
       puts "#{err.class()}: #{err.message}"
       puts "this should never happen, Did'nt i warn you?".red.blink
  	   display_help
       exit
    end
  end while 1
end

def list
  table_config = [
     {:key=>:name, :size=>19, :title=>"Name"},
     {:key=>:url, :size=>35, :title=>"URL"},
     {:key=>:account_id, :size=>15, :title=>"Account ID"}
  ]
  ConsoleTable.define(table_config) do |table|
      @config.each  do |r|
        table << [
          r[0].dup.colorize(:yellow),
          r[1]["url"],
          r[1]["account_id"]
        ]
      end
  end
end

def create_user(sis_id,full_name,email)
  # application/x-www-form-urlencoded
  # POST /api/v1/accounts/:account_id/users
  sel_config = @config[@active_config]
  parms = {
    "pseudonym[unique_id]" => email,
    "pseudonym[force_self_registration]" => true,
    "user[name]" => full_name,
    "pseudonym[sis_user_id]" => sis_id,
    "communication_channel[type]" => "email",
    "communication_channel[address]" => email,
    "pseudonym[send_confirmation]" => true,
  }
  begin
    RestClient.post "#{sel_config["canvas"]["url"]}/api/v1/accounts/#{sel_config["canvas"]["account_id"]}/users?access_token=#{sel_config["canvas"]["token"]}", parms, :accept => :json
  rescue RestClient::RequestFailed => e
    puts "The request failed with HTTP status code #{e.response.code}"
    puts "The body was:"
    puts e.response.body
    '{"id":0}'
  end

end

def run_import
  if @file.nil? or !File.file? @file
    puts "Import file not found, please check your path".red
  end
  new_user_list = CSV.read(@file, headers:true)
  new_user_list.each do |u|
    puts "Adding #{u["Name"]}, #{u["e-mail"]}".blue
    result = JSON.parse(create_user(u["SIS_ID"],u["Name"],u["e-mail"]))
    puts "Canvas ID: #{result["id"]}".yellow
  end
end

generate_example_config
load_config
parse_cli
if @file != ""  && @active_config != ""
  run_import
end
