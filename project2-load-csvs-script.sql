DROP DATABASE IF EXISTS nba_betting;
CREATE DATABASE nba_betting;
USE nba_betting;


DROP TABLE IF EXISTS games;
CREATE TABLE IF NOT EXISTS games (
	game_id BIGINT,
    game_date DATETIME,
    matchup VARCHAR(20),
    team_id BIGINT,
    is_home TEXT(1),
    win_loss TEXT(1),
    win_amt INT,
    loss_amt INT,
    win_pct DEC(4,3),
    fgm INT,
    fga INT,
    fg_pct DEC(4,3),
    fg3m INT,
    fg3a INT,
    fg3_pct DEC(4,3),
    ftm INT,
    fta INT,
    ft_pct DEC(4,3),
    oreb INT,
    dreb INT,
    reb INT,
    ast INT,
    stl INT,
    blk INT,
    tov INT,
    fouls INT,
    pts INT,
    opp_id BIGINT,
    season_year INT,
    season_type VARCHAR(40),
    season VARCHAR(20)
);

LOAD DATA INFILE "C:/Users/skand/Documents/Vanderbilt/3rd Year/CS 3265/data_csvs/nba-stats-betting/nba_games_all.csv"
INTO TABLE games 
FIELDS TERMINATED BY ',';


DROP TABLE IF EXISTS betting_lines;

CREATE TABLE IF NOT EXISTS betting_lines (
	game_id BIGINT,
	sportsbook_name VARCHAR(20),
    book_id BIGINT,
    team_id BIGINT,
    opp_team_id BIGINT,
    price1 INT SIGNED,
    price2 INT SIGNED
);

LOAD DATA INFILE "C:/Users/skand/Documents/Vanderbilt/3rd Year/CS 3265/data_csvs/nba-stats-betting/nba_betting_money_line.csv"
INTO TABLE betting_lines 
FIELDS TERMINATED BY ','
IGNORE 1 LINES;


DROP TABLE IF EXISTS betting_spreads;
CREATE TABLE IF NOT EXISTS betting_spreads (
	game_id BIGINT,
    book_name VARCHAR(20),
    book_id BIGINT,
    team_id BIGINT,
    opp_team_id BIGINT,
    spread1 DEC(4,1),
    spread2 DEC(4,1),
    price1 INT SIGNED,
    price2 INT SIGNED
    );

LOAD DATA INFILE "C:/Users/skand/Documents/Vanderbilt/3rd Year/CS 3265/data_csvs/nba-stats-betting/nba_betting_spread.csv"
INTO TABLE betting_spreads
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

DROP TABLE IF EXISTS player_game_data;
CREATE TABLE IF NOT EXISTS player_game_data (
	season_id INT,
    player_id BIGINT,
    player_name VARCHAR(50),
    team_id BIGINT,
	team_abbr TEXT(3),
    team_name VARCHAR(50),
    game_id BIGINT,
    game_date DATE,
    matchup VARCHAR(50),
    win_loss TEXT(1),
    minutes INT,
    fgm INT,
    fga INT,
    fg_pct DEC(4,3),
    fg3m INT,
    fg3a INT,
    fg3_pct DEC(4,3),
    ftm INT,
    fta INT,
    ft_pct DEC(4,3),
    oreb INT,
    dreb INT,
    reb INT,
    ast INT,
    stl INT,
    blk INT,
    tov INT,
    pf INT,
    pts INT,
    plus_minus INT,
    season_type VARCHAR(20),
    season_year INT,
    season VARCHAR(10)
    );

LOAD DATA INFILE "C:/Users/skand/Documents/Vanderbilt/3rd Year/CS 3265/data_csvs/nba-stats-betting/nba_players_game_stats.csv"
INTO TABLE player_game_data
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES
(season_id,player_id,player_name,team_id,team_abbr,team_name,game_id,game_date,
matchup,win_loss,minutes,fgm,@fga,@fg_pct,@fg3m,@fg3a,@fg3_pct,@ftm,@fta,@ft_pct,@oreb,
@dreb,@reb,@ast,@stl,@blk,@tov,@pf,pts,@plus_minus,season_type,season_year,season)
SET
fga = NULLIF(@fga, ''),
fg_pct = NULLIF(@fg_pct, ''),
fg3m = NULLIF(@fg3m, ''),
fg3a = NULLIF(@fg3a, ''),
fg3_pct = NULLIF(@fg3_pct, ''),
ftm = NULLIF(@ftm, ''),
fta = NULLIF(@fta, ''),
ft_pct = NULLIF(@ft_pct, ''),
oreb = NULLIF(@oreb, ''),
dreb = NULLIF(@dreb, ''),
reb = NULLIF(@reb, ''),
ast = NULLIF(@ast, ''),
stl = NULLIF(@stl, ''),
blk = NULLIF(@blk, ''),
tov = NULLIF(@tov, ''),
pf = NULLIF(@pf, ''),
plus_minus = NULLIF(@plus_minus, '')
;
    
DROP TABLE IF EXISTS player_info;
CREATE TABLE IF NOT EXISTS player_info (
	person_id BIGINT,
    last_comma_first VARCHAR(50),
    first_last VARCHAR(50),
    is_active TEXT(1),
    from_year INT,
    to_year INT,
    playercode VARCHAR(50),
    games_played TEXT(1),
    pos VARCHAR(30),
    draft_year INT,
    draft_round TINYINT, 
    height_feet TINYINT,
    height_inches TINYINT, 
    height DEC(11,10), 
    weight INT,
    season_exp INT,
    school VARCHAR(50),
    country VARCHAR(50),
    last_affiliation VARCHAR(50)
    );
    
LOAD DATA INFILE "C:/Users/skand/Documents/Vanderbilt/3rd Year/CS 3265/data_csvs/nba-stats-betting/nba_players_all.csv"
INTO TABLE player_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
IGNORE 1 LINES
(person_id, last_comma_first, first_last, is_active, @from_year, @to_year, playercode,
games_played,@pos, @draft_year, @draft_round, @height_feet, @height_inches, @height, @weight,
season_exp, @school, country, last_affiliation)
SET
from_year = NULLIF(@from_year, ''),
to_year = NULLIF(@to_year, ''),
pos = NULLIF(@pos, ''),
draft_year = NULLIF(@draft_year, ''),
draft_round = NULLIF(@draft_round, ''),
height_feet = NULLIF(@height_feet, ''),
height_inches = NULLIF(@height_inches, ''),
height = NULLIF(@height, ''),
weight = NULLIF(@weight, ''),
school = NULLIF(@school, '')
;



    

