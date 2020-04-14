SET sql_safe_updates =0;

-- limiting the study to games played after 2015
DROP TABLE IF EXISTS games_filtered;
CREATE TABLE IF NOT EXISTS games_filtered AS
SELECT game_id, game_date, team_id, is_home, win_loss, fg_pct, tov, pts, opp_id FROM games
WHERE game_date IS NOT NULL AND game_date > "2015-01-01";
    
-- want to see if shooting% and turnovers affect anything, so making a table with fg% and tov
-- included with the results
DROP TABLE IF EXISTS game_results_collection;
CREATE TABLE IF NOT EXISTS game_results_collection AS
SELECT team_1.game_id AS game_id, team_1.game_date, team_1.team_id AS team1_id, team_2.team_id as team2_id,
team_1.is_home, team_1.win_loss,  team_1.pts AS team1_pts, team_2.pts AS team2_pts, team_1.fg_pct AS team_1_fg_pct, team_2.fg_pct AS team_2_fg_pct,
team_1.tov AS team_1_tov, team_2.tov AS team_2_tov
FROM games_filtered team_1
INNER JOIN games_filtered team_2
ON team_1.game_id = team_2.game_id AND team_1.opp_id = team_2.team_id
GROUP BY game_id;


-- ONLY FOR Bovada - creation of the dashboard without team names, but including point spreads
-- Point spreads are a measure of how much a team needs to win by (or can lose by) for a bettor to win.
-- For example, if the spread of Houston vs. Los Angeles is -4.5 in favor of Houston, then Houston needs
-- to win by 5 points for a bettor to win their Houston bet. Conversely, if Los Angeles loses by less than 5,
-- a bettor who chose Los Angeles will still win their bet.
DROP TABLE IF EXISTS games_spreads_dashboard;
CREATE TABLE IF NOT EXISTS games_spreads_dashboard AS
SELECT game_results_collection.game_id, game_date, is_home, team1_id, team2_id,
win_loss, team1_pts, team2_pts, team_1_fg_pct, team_2_fg_pct, team_1_tov, team_2_tov, spread1, price1,
CASE WHEN (team1_pts + spread1 > team2_pts) THEN TRUE ELSE FALSE END AS ifCovered
FROM game_results_collection 
INNER JOIN betting_spreads
ON game_results_collection.game_id = betting_spreads.game_id
WHERE book_id = 999996;

-- adding team names with join, now we have a working table to create our visualizations
DROP TABLE IF EXISTS games_spreads_dashboard_names;
CREATE TABLE IF NOT EXISTS games_spreads_dashboard_names AS
SELECT game_id, game_date, is_home, team1.team_abbr AS team1_abbr, team1_id, 
team2.team_abbr AS team2_abbr, team2_id, win_loss AS team1_result, team1_pts, team2_pts, 
team_1_fg_pct, team_2_fg_pct, team_1_tov, team_2_tov, spread1, ifCovered
FROM games_spreads_dashboard
INNER JOIN team_info team1
ON games_spreads_dashboard.team1_id = team1.team_id
INNER JOIN team_info team2
ON games_spreads_dashboard.team2_id = team2.team_id;

-- making sure our new games_spread dashboard with names has a primary and foreign keys.
ALTER TABLE games_spreads_dashboard_names
ADD CONSTRAINT pk_dashboard_gameInfo PRIMARY KEY (game_id, team1_id, team2_id),
ADD CONSTRAINT fk_team1_dashboard FOREIGN KEY (team1_id, team1_abbr)
	REFERENCES team_info(team_id, team_abbr),
ADD CONSTRAINT fk_team2_dashboard FOREIGN KEY (team2_id, team2_abbr)
	REFERENCES team_info(team_id, team_abbr),
ADD CONSTRAINT fk_game_tm1_dashboard FOREIGN KEY 
	(game_id, game_date, team1_id, is_home, team1_result, 
	team_1_fg_pct, team_1_tov, team1_pts)
	REFERENCES games(game_id, game_date, team_id, is_home, win_loss, fg_pct, tov, pts),
ADD CONSTRAINT fk_game_tm2_dashboard FOREIGN KEY 
	(game_id, game_date, team2_id, team2_pts, team_2_fg_pct, team_2_tov)
    REFERENCES games(game_id, game_date, team_id, pts, fg_pct, tov),
ADD CONSTRAINT fk_spreads_tm1 FOREIGN KEY (game_id, team1_id, spread1)
	REFERENCES betting_spreads(game_id, team_id, spread1);

-- The last two tables we made were just intermediates b/c having 6 Inner joins was way too expensive computationally, 
-- so we will now drop them since we have no use for them anymore, since they are extraneous.
DROP TABLE IF EXISTS game_results_collection;
DROP TABLE IF EXISTS games_spreads_dashboard;

-- reset sql safe updates
SET sql_safe_updates = 1;






