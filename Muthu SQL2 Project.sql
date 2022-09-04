use miniproj;
select * from `icc test batting figures`;
alter table `icc test batting figures` rename to icc_test_batting_figures;

#Tasks to be performed:
#1.	Import the csv file to a table in the database.
#imported
#2.	Remove the column 'Player Profile' from the table.
alter table icc_test_batting_figures drop column `player profile`;

#3.	Extract the country name and player names from the given data and store it in seperate columns for further 
# usage.
select player,substr(player,1,instr(player,'(')-1) 
from icc_test_batting_figures;

select player,substr(player,locate('(',player)+1, locate(')',player) - locate('(' , player) -1) 
from icc_test_batting_figures;

alter table icc_test_batting_figures
add column country varchar (50);

update icc_test_batting_figures
set player_name= substr(player,1,instr(player,'(')-1),
country=substr(player,locate('(',player)+1, locate(')',player) - locate('(' , player) -1);

#4.	From the column 'Span' extract the start_year and end_year and store them in seperate columns for further 
# usage.
select player,span, substr(span,1,instr(span,'-')-1) from icc_test_batting_figures;

select player,span, substr(span,1,instr(span,'-')-1),substr(span,locate('-',span)+1) 
from icc_test_batting_figures;

alter table icc_test_batting_figures add column start_year varchar(20);
alter table icc_test_batting_figures add column end_year varchar(20);

update icc_test_batting_figures set end_year = substr(span,locate('-',span)+1);

#5.	The column 'HS' has the highest score scored by the player so far in any given match. 
# The column also has details if the player had completed the match in a NOT OUT status. 
# Extract the data and store the highest runs and the NOT OUT status in different columns.
select  HS from icc_test_batting_figures where HS like '%*%';

select  * from icc_test_batting_figures where HS not like '%*%';

alter table icc_test_batting_figures add column player_notout varchar(20);

update icc_test_batting_figures set  player_out =  HS  where HS not like '%*%';

#6.	Using the data given, considering the players who were active in the year of 2019, create a set of batting 
# order of best 6
-- players using the selection criteria of those who have a good average score across all matches for India.
select player,dense_rank() over (order by (runs) desc) 
from icc_test_batting_figures 
where end_year > 2018 and  country like '%ind%' limit 6;

select  player_name,country 
from icc_test_batting_figures 
where country like '%ind%' and  end_year > 2018 order by avg desc;

#7.	Using the data given, considering the players who were active in the year of 2019, create a set of batting 
# order of best 6 players using
-- the selection criteria of those who have highest number of 100s across all matches for India.
select  * from icc_test_batting_figures ;

select  player_name,country 
from icc_test_batting_figures 
where country like '%ind%' and  end_year > 2018   order by `100` desc;

#8.	Using the data given, considering the players who were active in the year of 2019, 
# create a set of batting order of best 6 players using
-- 2 selection criterias of your own for India.
select  player_name,country 
from icc_test_batting_figures 
where country like '%ind%' and end_year > 2018 and runs > 1000 
order by avg desc limit 6;

#9.	Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, 
# considering the players who were active in the year of 2019
-- , create a set of batting order of best 6 players using the selection criteria of those who have a good average score across all matches
-- for South Africa.

create view Batting_Order_GoodAvgScorers_SA as 
(select  player_name,country from icc_test_batting_figures where country like '%SA%' 
and  end_year > 2018   order by avg desc limit 6);

#10.	Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given, 
# considering the players who were active in the
-- year of 2019, create a set of batting order of best 6 players using the selection criteria of those 
-- who have highest number of 100s across all matches for South Africa.
create view Batting_Order_HighestCenturyScorers_SA as 
(select  player_name,country 
from icc_test_batting_figures 
where country like '%SA%' and  end_year > 2018   
order by `100` desc limit 6);


