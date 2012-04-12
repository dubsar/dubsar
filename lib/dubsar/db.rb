class DB
  class Field
    Types = {
      "String"  => "VARCHAR(255)",
      "Text"    => "TEXT",
      "Integer" => "INTEGER",
      "Binary"   => "BYTEA"
    }
    TypesCollection = Types.keys.sort

    attr_reader :name, :type
    def initialize(_name, _type)
      check_name(_name)
      check_type(_type)
      @name, @type = _name, Types[_type]
    end
    private
    def check_name(_name)
      ok = _name.length < 63 # max pg object's label name lenght see pg_type::name
      ok = ok && !DB.exists?(_name)
      raise "Invalid Table Name #{_name}" unless ok
    end
    def check_type(_type)
      ok = Types.has_key?(_type)
      raise "Invalid Type Name #{_type}" unless ok
    end
  end
  class << self
    def create_entity(name, parent = "entities", fields = [])
      routing_create_table name, parent, fields, "entity"
    end
    def create_thing(name, parent = "things", fields = [])
      routing_create_table name, parent, fields, "thing"
    end
    def exists?(_table_name)
      execute("SELECT count(*) AS count FROM pg_class WHERE relname = $1", [_table_name]).each do |row|
        return row['count'] == '1'
      end
    end
    private
    def routing_create_table(name, parent, fields, sequence)
      create_table name, parent, fields, sequence
      reload_routes
    end
    def create_table(name, parent, fields, sequence)
      sql = "CREATE TABLE dubsar.#{name} ("
      fields.each do |field|
        sql << field.name << " " << field.type << ","
      end
      sql << "PRIMARY KEY(id),"
      sql << "FOREIGN KEY(id) REFERENCES dubsar.#{sequence}_ids(id)"
      sql << ") INHERITS(#{parent})"
      execute sql
    end
    def connection
      ActiveRecord::Base.connection.instance_variable_get(:@connection)
    end
    def execute(_sql, _values = [])
      connection.exec _sql, _values
    end
    def reload_routes
      Dubsar::Application.reload_routes!
    end
  end
end
