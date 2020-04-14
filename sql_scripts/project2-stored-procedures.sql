

SET sql_safe_updates = 0;

-- stored procedure to update rows in dashboard
-- this is to make the visualizations in Tableau more user friendly.
-- For example, right now we have a boolean value that is T or F for the attribute isHome.
-- We want to change that to "home" and "road" rather than "T" and "f"
-- We also want to make a table that adds a column and answers "Yes" if team 1 covered the spread,
-- and "no" if they did not cover the spread
DROP PROCEDURE IF EXISTS makeReadableStrings;
DELIMITER //
CREATE PROCEDURE makeReadableStrings()
BEGIN
	UPDATE games_spreads_dashboard_names
	SET is_home = "Road" WHERE is_home = 'f';
    
	UPDATE games_spreads_dashboard_names
	SET is_home = "Home" WHERE is_home = 't';
    
    SET sql_safe_updates = 1;
    
END //
DELIMITER ;


-- Test to see if it works
CALL makeReadableStrings();

-- Stored procedure to ensure percentages are correct, if not change them
-- Some percentages in this dataset are inaccurate due to lazy code used to scrape the info
-- Thus, the Free throw, Field goal, win percentage for games, and 3-point percentages must be updated.
-- ONLY CALL THIS ON player_game_data, games, 
DROP PROCEDURE IF EXISTS fix_pcts;
DELIMITER //
CREATE PROCEDURE fix_pcts(IN tbl_name VARCHAR(30))
BEGIN

	IF tbl_name NOT LIKE "games" AND tbl_name NOT LIKE "player_game_data" THEN
		SIGNAL SQLSTATE '22003'
		SET MESSAGE_TEXT = "Can only be called on games or player_game_data tables.",
		MYSQL_ERRNO = 1264;
	END IF;
    
    IF tbl_name LIKE "games" THEN
		UPDATE games
		SET ft_pct = CASE
		WHEN fta != 0 THEN ROUND(ftm/fta, 3)
		ELSE NULL
        END;
        
        UPDATE games
		SET win_pct = CASE
		WHEN (win_amt + loss_amt != 0) THEN (ROUND(win_amt/(win_amt+loss_amt),3))
		ELSE NULL
		END;
        
		UPDATE games
		SET fg3_pct = CASE
		WHEN fg3a != 0 THEN ROUND(fg3m/fg3a, 3)
		ELSE NULL
		END;
		
		UPDATE games
		SET fg_pct = CASE
		WHEN fga != 0 THEN ROUND(fgm/fga, 3)
		ELSE NULL
		END;

	ELSE 
		UPDATE player_game_data
		SET ft_pct = CASE
		WHEN fta != 0 THEN ROUND(ftm/fta, 3)
		ELSE NULL
		END; 
     
 		UPDATE player_game_data
		SET fg3_pct = CASE
		WHEN fg3a != 0 THEN ROUND(fg3m/fg3a, 3)
		ELSE NULL
		END;

		UPDATE player_game_data
		SET fg_pct = CASE
		WHEN fga != 0 THEN ROUND(fgm/fga, 3)
		ELSE NULL
		END;
	
	END IF;
END //

DELIMITER ;

-- test to make sure this works, games should have lots of pct's to fix but players' should all be correct.
CALL fix_pcts("games");
CALL fix_pcts("player_game_data");

SET sql_safe_updates = 1;
