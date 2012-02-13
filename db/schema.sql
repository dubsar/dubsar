CREATE TABLE subject_ids (id SERIAL PRIMARY KEY);
CREATE TABLE subjects (id INTEGER PRIMARY KEY REFERENCES subject_ids(id));
CREATE VIEW subject_types AS SELECT p.relname, s.id FROM pg_class p, subjects s WHERE s.tableoid = p.oid;
CREATE TABLE people (name TEXT, PRIMARY KEY(id), FOREIGN KEY(id) REFERENCES subject_ids(id)) INHERITS(subjects);
CREATE TABLE institutions (name TEXT, PRIMARY KEY(id), FOREIGN KEY(id) REFERENCES subject_ids(id)) INHERITS(subjects);

