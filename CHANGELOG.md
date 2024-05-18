- To Be Implemented
  - Need to code system in so that if the attacker is not playing, they are not notified they gave a drink to someone else
  - Put Weaponchecks in a function
  - Domination on Assist reports that killer had domination
  - If non-player kills player, do not notify either

- Non-implemented rules
  - Rule 6: Would have to hardcode detection of every hat.
  - Rule 8: No way in SourceMod to detect whether a player is looking at a spray.
  - Rule A7: Buff banner impossible, as no separation between it and a normal crit.
  - Rule A10: Ubercharge gain from melee weapon does not notify event of anything on a kill. Infeasible to process.
  - Rule A11: Noscope impossible, as no separation. Alternative to base off damage done is infeasible due to having to work off player_death, not player_hurt (where damage accumulates)
  - Rule A12: Difficult to do without tipping someone off as to DR. Not implemented for now.
  - Rule A13: Similar to Rule 8, no way to determine if player sees the spycrab.

1.4.0.0 7/6/2020 JousterL
  - Added pragma #undef REQUIRE_EXTENSIONS to allow plugin to work in TF Classic. + 0.0.9.9

1.3.0.1 12/4/2011 JousterL
  - Fixed a bug introduced when I re-spaced everything that stopped advanced rules from functioning on normal deaths. +0.0.0.1
  - Added new #include for color handling. Red text means you have to take a drink, green text means you gave a drink, blue means you gave and take a drink. +0.0.8.6
           
1.2.1.4 10/11/2011 JousterL
  - Fixed missing If statement for sandman kill on Cirrhosis mode. +0.0.0.1
  - Added detection of machina penetration kills. 2 drinks for 1 penetration, 4 for 2, any more and finish drink. +0.0.1.0
    Caveats: The penetrated individuals must be playing, and it will fire for each such individual penetrated, leading to some spam.
  - Added full-uber death, which is 4 drinks on any difficulty. +0.0.1.0
  - Fixed bug with Domination/Revenge precluding advanced weapon detection. This must have been long-standing. +0.1.0.0
           
1.0.9.3 10/9/2011 JousterL
  - Added NikkyVix Suicide Cirrhosis Mode, where you take the same number of drinks you dish out. +0.0.1.0
  - Fixed typo in notifications. +0.0.0.2
  - Changed code for various notifications from || of each possibility to > for minimum number (so, for example, if(checkname>2), rather than if(checkname==2||checkname==3). +0.0.5.0

1.0.3.1 9/20/2011 JousterL
  - Added EmitSoundToClient calls to play a 'burp' sound whenever one needs to take a drink. +0.0.1.0
  - Fixed errors in EventBalancer and EventAchieve and EventStun where playing extreme rules wouldn't detect. +0.0.0.3
           
1.0.1.8 3/28/2011 JousterL
  - Corrected odd removal of if(num_drinks>0) check line in Adv_Rules. +0.0.0.1
  - Corrected team numbers for Red Team win on Event_Win. Need to swap the team numbers when I duplicate a function. +0.0.0.1
  - Added detection for Dead Ringer, so DR deaths don't spam the spy. +0.0.0.5
     
1.0.1.1 3/27/2011 JousterL
  - Fixed a bug in the mass notify functions not sending notifications out to triple-asterisked players. +0.0.0.1
     
1.0.1.0 3/26/2011 JousterL
  - Added tripe asterisk detection (*** at end of name) for super-verbosity. Take a drink every time ANYONE kills you!
             
1.0.0.2 11/24/2010 JousterL
  - Optimize by switch(reason) in Event_Win. +0.0.0.1
  - Optimize by removing if/else if/else do nothing functions in Event_Notify. +0.0.0.1

1.0.0.0 11/16/2010 JousterL
  - Made kill tracking additive (concatenated strings, variable containing # of drinks, one PrintToChat at end if # of drinks is >0). +0.1.0.0
  - Changed from manual concatenation of strings to Format() functionality to improve readibility, minimize code, and save processing. +0.1.0.0
  - Fixed a glitch with Sniper arrow taunt. +0.0.0.1
  - Added suggestion by Sal for fish kill to give an additional drink in Advanced Mode. +0.0.0.1
  - Removed Sandvich for now, as a player picking up a Sandvich is "HealOnHit" entindex 3, not stealsandvich. +0.0.0.1
  - Verified all branches are operational. +0.2.8.0
             
0.5.1.7 11/15/2010 JousterL
  - Implemented advanced kill detection for syringe gun. +0.0.0.1
  - Implemented player-triggered world death detection. +0.0.1.0
  - Restructured death code to use switch, removed spurious checks against attacker playing game (we don't really care). +0.0.0.5
    - Future modification: Move code over to separate function?
  - Above restructuring allowed implementation of Advanced rules still notifying if attacker is not playing. +0.0.1.0
  - Fixed a bug where a taunt triggered environmental code (Thx Valve for using the same weap_id for both World and Taunt kill). +0.0.0.1
  - Fixed a bug where team switching (suicide) triggered environmental code (Thx again Valve for using 'world' to kill a player on suicide). +0.0.0.1
    - Thanks to Jinx for finding this bug.
  - Assists implemented. +0.3.4.5
  - Advanced Mode - Airblasting implemented. +0.0.0.1
  - Advanced Mode - Taunt implemented. +0.0.1.0
  - Advanced Mode - Homewrecker implemented. +0.0.0.1
  - Advanced Mode - Huntsman Headshot implemented. +0.0.0.1
  - Advanced Mode - Gunslinger implemented. +0.0.0.1
  - Advanced Mode - Sandman + Sandman Death (Notify All) implemented. +0.0.0.2
  - Advanced Mode - Sandvich implemented. +0.0.0.1

0.1.2.7 11/14/2010 JousterL
  - Switched detection from simple "does asterisk exist in name" to more advanced delineation between if they're playing, and if so, if they're playing basic or advanced rules. +0.0.2.0
    - Thanks Acheron for the hint about indexing strings as arrays rather then trying to Split the string
  - Added notification code re: Nynn's suggestion for notification when a client joins a team if they're playing the drinking game. +0.0.1.0
  - Also added code for if a client changes their name. +0.0.0.3
  - Fixed a typo "take a drinks" in environmental death. +0.0.0.1
  - Implemented find and notification of multiple parties. Removed casting numbers as Int: as passing the numbers threw up Tag Mismatch warnings in both notifier functions. +0.0.5.0
  - Utilized above code to handle win distribution to drinking parties. +0.0.1.0
    - Added code to let the other team know.
  - Untested Achievement detection implementation. +0.0.0.1

0.0.3.2 11/13/2010 JousterL
  - Added detection of autobalance +0.0.0.1
  - Added pseudocode and partial structure for Achievement detection +0.0.0.1
    - Need to figure out how to set up an array of all users, parse through list looking for *
  - Added psuedocode and partial structure for Win detection +0.0.0.1
    - As above, need to figure out how to set up array of team users, and parse the list.
  - Changed to bitwise compare for Death Flags. Tested against bots. +0.0.1.5
  - Fixed a bug where sm_slay command causes the plugin to think the user is slayed by themselves. +0.0.0.1
  - Tested world death functionality, works correctly. +0.0.0.1

0.0.1.2 11/12/2010 JousterL
  - Initial code, informs user on death to take a drink, lets attacker know he forced a drink on user. +0.0.0.1
  - Added boundary case for world death, as tester Jinx demonstrated domination triggering error. Set to "attacker==0", untested. +0.0.0.1
  - Added code for domination detection/revenge detection. Simple comparison against death_flags. +0.0.1.0
    - May need to redo this, implement bitwise AND, as tester Jinx demonstrated multiple flags triggering (Dom + Feign = 33)... df&1, df&4, etc...
      - Dom = 1, Rev = 4, Feign = 32
