use ipl;

## 1.Show the percentage of wins of each bidder in the order of highest to lowest percentage
select STADIUM_NAME,CITY,round(sum(if(TOSS_WINNER=MATCH_WINNER,1,0))/count(if(TOSS_WINNER=MATCH_WINNER,1,0)),2) 
as Per_of_Wins
from ipl_stadium 
join ipl_match_schedule ims 
using (STADIUM_ID)
join ipl_match 
using (MATCH_ID)
group by STADIUM_NAME;

## 2. Display number of matches conducted at each stadium with stadium name, city from database.
select stadium_id, stadium_name, city, count(match_id)
from ipl_match_schedule 
join ipl_stadium
using(stadium_id)
group by stadium_id 
order by stadium_id;

## 3. In a given stadium, what is the percentage of wins by a team which has won the toss.
select BIDDER_ID,sum(if(BID_STATUS='Won',1,0)) as No_of_wins,
sum(if(BID_STATUS='Lost',1,0)) as No_of_Loss,
sum(if(BID_STATUS='Won',1,0))+sum(if(BID_STATUS='Lost',1,0))+sum(if(BID_STATUS='bid',1,0)) as Total_betting,
(sum(if(BID_STATUS='Won',1,0))/(sum(if(BID_STATUS='Won',1,0))+sum(if(BID_STATUS='Lost',1,0))+sum(if(BID_STATUS='bid',1,0))))*100 as percentage_of_wins
from ipl_bidding_details
group by BIDDER_ID
order by 5 desc;

## 4. show total bids along with bid team and team name.
select TEAM_NAME,BID_TEAM,count(BIDDER_ID) as no_of_bids
from ipl_team it 
join ipl_bidding_details ibd 
on it.TEAM_ID=ibd.BID_TEAM
group by TEAM_NAME
order by 2;

## 5. Show the team id who won the match as per win details.
select 
team_id1,team_id2,win_details,if(match_winner=1,team_id1,team_id2) win_team_id,team_name
from ipl_match im join ipl_team it
on it.team_id=if(match_winner=1,team_id1,team_id2);

## 6. Display total matches played, total matched won and total matches lost by team along with team_name .
select team_id, team_name, matches_played, matches_won, matches_lost 
from ipl_team_standings
join ipl_team
using(team_id) 
group by team_id; 

## 7. Display bowlers for Mumbai Indians team.
select team_id, team_name, player_id, player_role, player_name
from ipl_team_players
join ipl_team
using(team_id)
join ipl_player
using(player_id)
where team_name = 'Mumbai Indians' and player_role = 'Bowler' ;

## 8. (a) How many all rounders are there in each team
select team_id, team_name, player_id, player_role, count(*) as no_of_all_rounders 
from ipl_team_players
join ipl_team
using(team_id)
where player_role = 'All-Rounder' 
group by team_id;

## 8. (b) Display teams with more than 4 all rounders in descending order
select team_id, team_name, player_id, player_role, count(*) as no_of_all_rounders 
from ipl_team_players
join ipl_team
using(team_id)
where player_role = 'All-Rounder' 
group by team_id
having count(*) > 4 
order by count(*) desc ;


