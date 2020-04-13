SET sql_safe_updates =0;


DROP TABLE IF EXISTS games_filtered;
CREATE TABLE IF NOT EXISTS games_filtered AS
SELECT game_id, game_date, team_id, is_home, win_loss, fg_pct, tov, pts, opp_id FROM games
WHERE game_date IS NOT NULL AND game_date > "2015-01-01";
    

DROP TABLE IF EXISTS game_results_collection;
CREATE TABLE IF NOT EXISTS game_results_collection AS
SELECT team_1.game_id AS game_id, team_1.game_date, team_1.team_id AS team1_id, team_2.team_id as team2_id,
team_1.is_home, team_1.win_loss,  team_1.pts AS team1_pts, team_2.pts AS team2_pts, team_1.fg_pct AS team_1_fg_pct, team_2.fg_pct AS team_2_fg_pct,
team_1.tov AS team_1_tov, team_2.tov AS team_2_tov
FROM games_filtered team_1
INNER JOIN games_filtered team_2
ON team_1.game_id = team_2.game_id AND team_1.opp_id = team_2.team_id
GROUP BY game_id;


-- ONLY FOR Bovada - creation of the dashboard without team names!
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
DROP TABLE IF EXISTS games_spreads_dash_names;
CREATE TABLE IF NOT EXISTS games_spreads_dash_names AS
SELECT game_id, game_date, is_home, team1.team_abbr AS team1_abbr, team1_id, 
team2.team_abbr AS team2_abbr, team2_id, win_loss AS team1_result, team1_pts, team2_pts, 
team_1_fg_pct, team_2_fg_pct, team_1_tov, team_2_tov, spread1, ifCovered
FROM games_spreads_dashboard
INNER JOIN team_info team1
ON games_spreads_dashboard.team1_id = team1.team_id
INNER JOIN team_info team2
ON games_spreads_dashboard.team2_id = team2.team_id;


UPDATE games_spreads_dash_names
SET is_home = "Road" WHERE is_home = 'f';
UPDATE games_spreads_dash_names
SET is_home = "Home" WHERE is_home = 't';
ALTER TABLE games_spreads_dash_names
ADD coveredText VARCHAR(4);
UPDATE games_spreads_dash_names
SET coveredText = "Yes" WHERE ifCovered = 1;
UPDATE games_spreads_dash_names
SET coveredText = "No" WHERE ifCovered = 0;







