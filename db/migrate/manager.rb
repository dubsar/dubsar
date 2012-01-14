class Manager < ActiveRecord::Migration
  def up
    sql = load('create')
    execute sql
  end
  def down
    sql = load('drop')
    execute sql
  end
  def load(script)
    sql = ""
    source = File.new("#{Rails.root}/db/sql/#{script}.sql", "r")
    while (line = source.gets)
        sql << line
    end
    source.close
    sql
  end
end
