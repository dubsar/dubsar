class Migrator < ActiveRecord::Migration
	class << self
		def create_master
      create
    end
    def create_heroku
      create "heroku"
    end
    def drop
      run "common_drop"
    end
    private
		def create(version="master")
			%W(data references functions).each do |section|
				run "common_#{section}"
			end
      run "#{version}_functions"
		end
    def run(_method)
			send(_method).each do |file|
					puts "processing " << file
          sql = read_file(sql_file(file))
          execute sql
			end
    end
    def read_file(_file_name)
      sql = ""
      source = File.new(_file_name, "r")
      while (line = source.gets)
          sql << line
      end
      source.close
      sql
    end
    def sql_root
      File.join Rails.root, "db", "sql"
    end
    def sql_file(_file_name)
      File.join(sql_root, _file_name)
    end
    def read_migrator
      haml = File.read(File.join(sql_root, "migrator.haml"))
			Nokogiri::XML(Haml::Engine.new(haml).render)
    end
		def migrator
      @@xml ||= read_migrator
		end
		def common
			@@common ||= migrator.css "create common"
		end
		def common_data
			@@common_data ||= to_array common.css "data file"
		end
		def common_references
			@@common_references ||= to_array common.css "references file"
		end
		def common_functions
			@@common_functions ||= to_array common.css "functions file"
		end
		def specific
			@@specific ||= migrator.css "create specific"
		end
		def master_functions
			@@master_functions ||= to_array specific.css "master functions file"
		end
		def heroku_functions
			@@heroku_functions ||= to_array specific.css "heroku functions file"
		end
		def common_drop
			@@common_drop ||= to_array migrator.css "drop"
		end
		def to_array(nodes)
			array = []
			nodes.each {|node| array << node.text()}
			array
		end
	end
end
