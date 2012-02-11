CREATE OR REPLACE FUNCTION dubsar.add_to_searches(INT, TEXT, TEXT, TEXT) RETURNS INTEGER  AS $$
	INSERT INTO dubsar.searches(item_id, item_relation, description, content) VALUES (
		$1,
		$2,
		substr(($3), 0, 100), 
		to_tsvector($4)
	);
	SELECT 1;
	$$ LANGUAGE sql;

CREATE OR REPLACE RULE youtube_videos_search AS 
	ON INSERT
	TO dubsar.youtube_videos
	DO SELECT dubsar.add_to_searches(
		new.id - 1,
		'youtube_videos',
		new.title,
		new.description
	);
