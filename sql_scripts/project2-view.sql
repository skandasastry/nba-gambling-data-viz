
-- See all betting info (point spread, money line, over/under) for every game
-- Just for the sportsbook "Bovada", one of 6 in our database.
-- Note that team 1 is by definition on the road while team2 is by definition home.
DROP VIEW IF EXISTS bovada_games_info;
CREATE VIEW bovada_games_info AS 
SELECT gameDash.game_date, gameDash.is_home, gameDash.team1_abbr AS team1_name, 
gameDash.team2_abbr AS team2_name, gameDash.team1_result, gameDash.team1_pts AS team1_pts,
gameDash.team2_pts AS team2_pts, gameDash.spread1, overs.overUnder1, mLines.price1 AS mLine1
FROM games_spreads_dashboard_names gameDash
INNER JOIN betting_overunders overs ON overs.game_id = gameDash.game_id AND (gameDash.team1_id = overs.team_id OR gameDash.team2_id = overs.opp_id)
INNER JOIN betting_lines mLines ON overs.game_id = mLines.game_id AND (gameDash.team1_id = mLines.team_id OR gameDash.team2_id = mLines.opp_team_id)
WHERE mLines.book_id = 999996 AND overs.book_id = 999996;

-- Test if this view works
SELECT * FROM bovada_games_info;

-- same view as above, betting info View but for Pinnacle Sports, another sportsbook
DROP VIEW IF EXISTS pinnacle_sports_info;
CREATE VIEW pinnacle_sports_info AS 
SELECT gameDash.game_date, gameDash.is_home, gameDash.team1_abbr AS team1_name, 
gameDash.team2_abbr AS team2_name, gameDash.team1_result, gameDash.team1_pts AS team1_pts,
gameDash.team2_pts AS team2_pts, gameDash.spread1, overs.overUnder1, mLines.price1 AS mLine1
FROM games_spreads_dashboard_names gameDash
INNER JOIN betting_overunders overs ON overs.game_id = gameDash.game_id AND (gameDash.team1_id = overs.team_id OR gameDash.team2_id = overs.opp_id)
INNER JOIN betting_lines mLines ON overs.game_id = mLines.game_id AND (gameDash.team1_id = mLines.team_id OR gameDash.team2_id = mLines.opp_team_id)
WHERE mLines.book_id = 238 AND overs.book_id = 238;

SELECT * FROM pinnacle_sports_info;


