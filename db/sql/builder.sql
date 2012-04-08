CREATE TYPE dubsar.field AS (name varchar, type varchar);
CREATE OR REPLACE FUNCTION dubsar.to_field(name varchar, type varchar) RETURNS dubsar.field AS $$
	declare
		field field;
	begin
		SELECT name, type INTO field;
		RETURN field;
	end
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_entity(name varchar, parent varchar, fields field[]) returns TEXT AS $$
declare
	sql TEXT '';
begin
	sql := 'CREATE TABLE $1 (';
	FOREACH field in fields LOOP
		sql := sql | field.name | ' ' | field.type | ','
	END LOOP
	sql := 'FOREIGN KEY(id) REFERENCES dubsar.entity_ids(id)'
	RETURN sql;
end
$$ LANGUAGE plpgsql;

	
