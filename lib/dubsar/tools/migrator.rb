class Migrator < ActiveRecord::Migration
  class << self
    def drop
      run "drop_schema"
    end
    def create
      run "create_schema"
    end
    def push(_file)
      sql = read_sql(sql_file(_file))
      execute_sql sql
    end
    private
    def run(_method)
      send(_method).each do |file|
        puts "processing " << file
        sql = read_sql(sql_file(file))
        execute_sql sql
      end
    end
    def execute_sql(_sql)
      begin
        execute _sql
      rescue Exception => e
        puts e.message
      end
    end
    def read_sql(_sql_file)
      sql = ""
      source = File.new(_sql_file, "r")
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
    def create_schema
      to_array migrator.css "create"
    end
    def drop_schema
      to_array migrator.css "drop"
    end
    def to_array(_file_list)
      _file_list.text().split(/\s/).reject {|s| s.empty?}
    end
  end
end

