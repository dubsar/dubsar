CREATE TYPE dubsar.inh_tree AS (node OID, parent OID);

CREATE OR REPLACE VIEW dubsar.inheritance AS 
	SELECT DISTINCT i.inhparent AS node, NULL::oid AS parent
	FROM pg_inherits i
	WHERE NOT (i.inhparent IN ( SELECT pg_inherits.inhrelid FROM pg_inherits))
		UNION 
	SELECT pg_inherits.inhrelid AS node, pg_inherits.inhparent AS parent
	FROM pg_inherits
;

CREATE OR REPLACE FUNCTION dubsar.get_inh_tree(parent oid) RETURNS SETOF inh_tree AS
$$
	SELECT CAST((node, parent) AS inh_tree)
	FROM		 inheritance
	WHERE node = $1
		-- use ALL to avoid implicit DISTINCT (useless in this case) that may lead to
		-- ERROR:  could not identify an ordering operator for type inh_tree !
		UNION ALL
	SELECT get_inh_tree(parent)
	FROM inheritance
	WHERE node = $1
$$
LANGUAGE sql
;

CREATE OR REPLACE FUNCTION dubsar.get_inh_ancestry(oid) RETURNS character varying AS
$$
	SELECT array_to_string(array(SELECT parent FROM get_inh_tree($1	)), '/')
$$
LANGUAGE sql
;

CREATE OR REPLACE VIEW dubsar.inheritances AS 
 SELECT i.node::integer AS id, c.relname AS name, get_inh_ancestry(i.node) AS ancestry
 FROM inheritance i JOIN pg_class c ON i.node = c.oid
;
