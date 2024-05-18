        /*
        Changelog

        -Fixes
          -Need to code system in so that if the attacker is not playing, they are not notified they gave a drink to someone else
          -Put Weaponchecks in a function
          -Domination on Assist reports that killer had domination
          -If non-player kills player, do not notify either

        -Non-implemented rules
          -Rule 6: Would have to hardcode detection of every hat.
          -Rule 8: No way in SourceMod to detect whether a player is looking at a spray.
          -Rule A7: Buff banner impossible, as no separation between it and a normal crit.
          -Rule A10: Ubercharge gain from melee weapon does not notify event of anything on a kill. Infeasible to process.
          -Rule A11: Noscope impossible, as no separation. Alternative to base off damage done is infeasible due to having to work off player_death, not player_hurt (where damage accumulates)
          -Rule A12: Difficult to do without tipping someone off as to DR. Not implemented for now.
          -Rule A13: Similar to Rule 8, no way to determine if player sees the spycrab.

        1.1.0.0 7/6/2020 JousterL
        -Added pragma #undef REQUIRE_EXTENSIONS to allow plugin to work in TF Classic.

        1.0.1.8 3/28/2011 JousterL 
        -Corrected odd removal of if(num_drinks>0) check line in Adv_Rules. +0.0.0.1
        -Corrected team numbers for Red Team win on Event_Win. Need to swap the team numbers when I duplicate a function. +0.0.0.1
        -Added detection for Dead Ringer, so DR deaths don't spam the spy. +0.0.0.5
 
        1.0.1.1 3/27/2011 JousterL
        -Fixed a bug in the mass notify functions not sending notifications out to triple-asterisked players. +0.0.0.1
 
        1.0.1.0 3/26/2011 JousterL
        -Added tripe asterisk detection (*** at end of name) for super-verbosity. Take a drink every time ANYONE kills you!
         
        1.0.0.2 11/24/2010 JousterL
        -Optimize by switch(reason) in Event_Win. +0.0.0.1
        -Optimize by removing if/else if/else do nothing functions in Event_Notify. +0.0.0.1

        1.0.0.0 11/16/2010 JousterL
        -Made kill tracking additive (concatenated strings, variable containing # of drinks, one PrintToChat at end if # of drinks is >0). +0.1.0.0
        -Changed from manual concatenation of strings to Format() functionality to improve readibility, minimize code, and save processing. +0.1.0.0
        -Fixed a glitch with Sniper arrow taunt. +0.0.0.1
        -Added suggestion by Sal for fish kill to give an additional drink in Advanced Mode. +0.0.0.1
        -Removed Sandvich for now, as a player picking up a Sandvich is "HealOnHit" entindex 3, not stealsandvich. +0.0.0.1
        -Verified all branches are operational. +0.2.8.0
         
        0.5.1.7 11/15/2010 JousterL
        -Implemented advanced kill detection for syringe gun. +0.0.0.1
        -Implemented player-triggered world death detection. +0.0.1.0
        -Restructured death code to use switch, removed spurious checks against attacker playing game (we don't really care). +0.0.0.5
          -Future modification: Move code over to separate function?
        -Above restructuring allowed implementation of Advanced rules still notifying if attacker is not playing. +0.0.1.0
        -Fixed a bug where a taunt triggered environmental code (Thx Valve for using the same weap_id for both World and Taunt kill). +0.0.0.1
        -Fixed a bug where team switching (suicide) triggered environmental code (Thx again Valve for using 'world' to kill a player on suicide). +0.0.0.1
          -Thanks to Jinx for finding this bug.
        -Assists implemented. +0.3.4.5
        -Advanced Mode - Airblasting implemented. +0.0.0.1
        -Advanced Mode - Taunt implemented. +0.0.1.0
        -Advanced Mode - Homewrecker implemented. +0.0.0.1
        -Advanced Mode - Huntsman Headshot implemented. +0.0.0.1
        -Advanced Mode - Gunslinger implemented. +0.0.0.1
        -Advanced Mode - Sandman + Sandman Death (Notify All) implemented. +0.0.0.2
        -Advanced Mode - Sandvich implemented. +0.0.0.1

        0.1.2.7 11/14/2010 JousterL
        -Switched detection from simple "does asterisk exist in name" to more advanced delineation between if they're playing, and if so, if they're playing basic or advanced rules. +0.0.2.0
          -Thanks Acheron for the hint about indexing strings as arrays rather then trying to Split the string
        -Added notification code re: Nynn's suggestion for notification when a client joins a team if they're playing the drinking game. +0.0.1.0
        -Also added code for if a client changes their name. +0.0.0.3
        -Fixed a typo "take a drinks" in environmental death. +0.0.0.1
        -Implemented find and notification of multiple parties. Removed casting numbers as Int: as passing the numbers threw up Tag Mismatch warnings in both notifier functions. +0.0.5.0
        -Utilized above code to handle win distribution to drinking parties. +0.0.1.0
          -Added code to let the other team know.
        -Untested Achievement detection implementation. +0.0.0.1

        0.0.3.2 11/13/2010 JousterL
        -Added detection of autobalance +0.0.0.1
        -Added pseudocode and partial structure for Achievement detection +0.0.0.1
          -Need to figure out how to set up an array of all users, parse through list looking for *
        -Added psuedocode and partial structure for Win detection +0.0.0.1
          -As above, need to figure out how to set up array of team users, and parse the list.
        -Changed to bitwise compare for Death Flags. Tested against bots. +0.0.1.5
        -Fixed a bug where sm_slay command causes the plugin to think the user is slayed by themselves. +0.0.0.1
        -Tested world death functionality, works correctly. +0.0.0.1

        0.0.1.2 11/12/2010 JousterL
        -Initial code, informs user on death to take a drink, lets attacker know he forced a drink on user. +0.0.0.1
        -Added boundary case for world death, as tester Jinx demonstrated domination triggering error. Set to "attacker==0", untested. +0.0.0.1
        -Added code for domination detection/revenge detection. Simple comparison against death_flags. +0.0.1.0
          -May need to redo this, implement bitwise AND, as tester Jinx demonstrated multiple flags triggering (Dom + Feign = 33)... df&1, df&4, etc...
          -Dom = 1, Rev = 4, Feign = 32
        */

        #include <sourcemod>
        #undef REQUIRE_EXTENSIONS

        public Plugin:myinfo =
        {
            name = "The Furry Pound Drinking Game",
            author = "JousterL",
            description = "Automated notification of drinking events",
            version = "1.1.0.0",
            url = "http://www.furaffinity.net/user/jousterl"
        }

        public OnPluginStart()
        {
            HookEvent("player_death", Event_Death)
            HookEvent("teamplay_teambalanced_player", Event_Balancer)
            HookEvent("achievement_earned", Event_Achieve)
            HookEvent("teamplay_win_panel", Event_Win)
            HookEvent("player_changename", Notify)
            HookEvent("player_team", Notify2)
            HookEvent("player_hurt", Event_Stun)
        }

        //Event Handlers

        /*public Event_Sandvich(Handle:event, const String:name[], bool:dontBroadcast)
        {
            new rec = GetClientOfUserId(GetEventInt(event, "target"))
            new giv = GetClientOfUserId(GetEventInt(event, "owner"))
            new String:rName[128]
            new String:gName[128]
            GetClientName(rec, rName, 128)
            GetClientName(giv, gName, 128)
            if(CheckName(rName)==2)
            {
              PrintToChat(rec, "\x04Toast the heavy, %s, who gave you his sandvich for your life. Enjoy a drink.\x01", gName)
              if(CheckName(gName)==2)
              {
                 PrintToChat(giv, "\x04You saved %s with that sandvich. They toast your good health with a drink. Consider having one yourself.\x01", rName)
              }
            }
        }*/

        public Event_Stun(Handle:event, const String:name[], bool:dontBroadcast)
        {
            new cust_hit = GetEventInt(event, "custom")
            if(cust_hit==22)
            {
              new victim = GetClientOfUserId(GetEventInt(event, "userid"))
              new attacker = GetClientOfUserId(GetEventInt(event, "attacker"))
              new String:vName[128]
              new String:aName[128]
              GetClientName(victim, vName, 128)
              GetClientName(attacker, aName, 128)
              if(CheckName(vName)==2)
              {
                 PrintToChat(victim, "\x04%s stunned you with the sandman. Take a drink.\x01", aName)
                 PrintToChat(attacker, "\x04You stunned %s with the sandman. They take a drink.\x01", vName)
              }
            }
        }

        public Notify(Handle:event, const String:name[], bool:dontBroadcast)
        {
            new cl = GetClientOfUserId(GetEventInt(event, "userid"))
            new String:temp[128]
            GetEventString(event, "newname", temp, 128)
            new isDrink = CheckName(temp)
            if(isDrink==3)
            {
                PrintToChat(cl, "\x04Due to the structure of your name you have been flagged as participating in the Extreme Rules of the TFP drinking game, and will a notice every time someone kills you.\x01")
            }
            if(isDrink==2)
            {
                PrintToChat(cl, "\x04Due to the structure of your name you have been flagged as participating in the Advanced Rules of the TFP drinking game, and will receive more notices on when to take a drink.\x01")
            }
            if(isDrink==1)
            {
                PrintToChat(cl, "\x04Due to the structure of your name you have been flagged as participating in the TFP drinking game, and will receive notices on when to take a drink.\x01")
            }
        }

        public Notify2(Handle:event, const String:name[], bool:dontBroadcast)
        {
            new cl = GetClientOfUserId(GetEventInt(event, "userid"));
            if(cl!=0)
            {
                new String:temp[128]
                GetEventString(event, "name", temp, 128)
                new isDrink = CheckName(temp)
                if(isDrink==3)
                {
                    PrintToChat(cl, "\x04Due to the structure of your name you have been flagged as participating in the Extreme Rules of the TFP drinking game, and will a notice every time someone kills you.\x01")
                }
                if(isDrink==2)
                {
                    PrintToChat(cl, "\x04Due to the structure of your name you have been flagged as participating in the Advanced Rules of the TFP drinking game, and will receive more notices on when to take a drink.\x01")
                }
                if(isDrink==1)
                {
                    PrintToChat(cl, "\x04Due to the structure of your name you have been flagged as participating in the TFP drinking game, and will receive notices on when to take a drink.\x01")
                }
            }
        }

        public Event_Win(Handle:event, const String:name[], bool:dontBroadcast)
        {
            new win_team = GetEventInt(event, "winning_team")
            new reason = GetEventInt(event, "winreason") //Reason: 1=CP 3=Flag 4=defended 5=Stalemate/Death like below.
            if(win_team==3) //Blue team won
            {
              switch(reason)
              {
                 case 1:
                 {
                    NotifyTeamDrinkers(1, "The final point was captured!", 2, false)
                    NotifyTeamDrinkers(1, "The final point was captured!", 3, true)
                 }
                 case 3:
                 {
                    NotifyTeamDrinkers(1, "The final flag was captured!", 2, false)
                    NotifyTeamDrinkers(1, "The final flag was captured!", 3, true)
                 }
                 case 4:
                 {
                    NotifyTeamDrinkers(1, "The defense was too strong!", 2, false)
                    NotifyTeamDrinkers(1, "Your defense was too strong!", 3, true)
                 }
              }
            }
            else if(win_team==2) //Red team won
            {
              switch(reason)
              {
                 case 1:
                 {
                    NotifyTeamDrinkers(1, "The final point was captured!", 3, false)
                    NotifyTeamDrinkers(1, "The final point was captured!", 2, true)
                 }
                 case 3:
                 {
                    NotifyTeamDrinkers(1, "The final flag was captured!", 3, false)
                    NotifyTeamDrinkers(1, "The final flag was captured!", 2, true)
                 }
                 case 4:
                 {
                    NotifyTeamDrinkers(1, "The defense was too strong!", 3, false)
                    NotifyTeamDrinkers(1, "Your defense was too strong!", 2, true)
                 }
              }
            }
            else //Uh... uh-oh.
            {
              //Do nothing
            }
        }

        public Event_Achieve(Handle:event, const String:name[], bool:dontBroadcast)
        {
            new player_id = GetEventInt(event, "player")
            new String:temp[256]
            GetClientName(player_id,temp,128)
            new isDrink = CheckName(temp)
            if(isDrink==2 || isDrink==1)
            {
              StrCat(temp, 256, " got an Achievement!")
              NotifyAllDrinkers(2, temp)
            }
        }

        public Event_Balancer(Handle:event, const String:name[], bool:dontBroadcast)
        {
            new victim_id = GetEventInt(event, "player")
            new String:vName[128]
            GetClientName(victim_id,vName,128)
            new isDrink = CheckName(vName)
            if(isDrink==2 || isDrink==1)
            {
              PrintToChat(victim_id, "\x04Ouch, autobalanced. Have a drink for your sorrows.\x01");
            }
        }



        public Adv_Rules(Handle:event)
        {
            new victim = GetClientOfUserId(GetEventInt(event, "userid"))
            new attacker = GetClientOfUserId(GetEventInt(event, "attacker"))
            new assister = GetClientOfUserId(GetEventInt(event, "assister"))
            new String:aName[128]
            new String:vName[128]
            new String:sName[128]
            new String:weapon[128]
            GetClientName(victim,vName,128)
            GetClientName(attacker,aName,128)
            GetClientName(assister,sName,128)
            new aDrink = CheckName(aName)
            GetEventString(event, "weapon", weapon, 128)
            new df = GetEventInt(event, "death_flags")
            new cust_kill = GetEventInt(event, "customkill")
            new bool:spec_weap = false
            new bool:feign = false
            new String:vMessage[512]
            new String:aMessage[512]
            new num_drinks = 0
            //Step 1: World Deaths
            new wd = isWorldDeath(event, attacker, weapon, aDrink)
            switch (wd)
            {
              case 1:
              {
                 num_drinks++;
                 StrCat(vMessage, 512, "\x04You died to the world.")
              }
              case 2:
              {
                 num_drinks+=2;
                 Format(vMessage, sizeof(vMessage), "\x04%s got an environment kill on you.", aName)
                 Format(aMessage, sizeof(aMessage), "\x04You got an environment kill on %s.", vName)
              }
              case 3:
              {
                 num_drinks+=3;
                 Format(vMessage, sizeof(vMessage), "\x04%s got an environment kill on you, and is also playing the drinking game.", aName)
                 Format(aMessage, sizeof(aMessage), "\x04You got an environment kill on %s, and you are also playing the drinking game.", vName)
              }
            }
            //Step 2: Analysis of standard (non-environment) death
            if(wd==0)
            {
              if(victim!=attacker) //Avoids a bug with sm_slay
              {
                 if(df&32)
                 {
                    feign = true
                 }
                 //Step 2.1: Domination/Revenge code
                 if(df&1||df&2) //Did the attacker get a domination?
                 {
                    num_drinks+=2;
                    Format(vMessage, sizeof(vMessage), "\x04%s killed you, and dominated you.", aName)
                    Format(aMessage, sizeof(aMessage), "\x04You killed %s, and dominated them.", vName)
                 }
                 else if(df&4||df&8) //Did the attacker get a revenge?
                 {
                    num_drinks+=2;
                    Format(vMessage, sizeof(vMessage), "\x04%s killed you, and got a revenge on you.", aName)
                    Format(aMessage, sizeof(aMessage), "\x04You killed %s, and got a revenge on them.", vName)
                 }
                 //Step 2.2: Normal Kill, detect if weapon was one in Advanced Rules.
                 else
                 {
                    switch(cust_kill) //Step 2.2.1: Taunt detection
                    {
                        case 7: //Pyro Hadouken Taunt
                        {
                          num_drinks+=3;
                          Format(vMessage, sizeof(vMessage), "\x04%s taunt-killed you.", aName)
                          Format(aMessage, sizeof(aMessage), "\x04You taunt-killed %s.", vName)
                          spec_weap = true
                        }
                        case 9: //High noon
                        {
                          num_drinks+=3;
                          Format(vMessage, sizeof(vMessage), "\x04%s taunt-killed you.", aName)
                          Format(aMessage, sizeof(aMessage), "\x04You taunt-killed %s.", vName)
                          spec_weap = true
                        }
                        case 10: //Grand slam
                        {
                          num_drinks+=3;
                          Format(vMessage, sizeof(vMessage), "\x04%s taunt-killed you.", aName)
                          Format(aMessage, sizeof(aMessage), "\x04You taunt-killed %s.", vName)
                          spec_weap = true
                        }
                        case 13: //Spy Fencing Taunt
                        {
                          num_drinks+=3;
                          Format(vMessage, sizeof(vMessage), "\x04%s taunt-killed you.", aName)
                          Format(aMessage, sizeof(aMessage), "\x04You taunt-killed %s.", vName)
                          spec_weap = true
                        }
                        case 15: //Sniper Arrow Taunt
                        {
                          num_drinks+=3;
                          Format(vMessage, sizeof(vMessage), "\x04%s taunt-killed you.", aName)
                          Format(aMessage, sizeof(aMessage), "\x04You taunt-killed %s.", vName)
                          spec_weap = true
                        }
                        case 21: //Soldier Grenade Taunt
                        {
                          num_drinks+=3;
                          Format(vMessage, sizeof(vMessage), "\x04%s taunt-killed you.", aName)
                          Format(aMessage, sizeof(aMessage), "\x04You taunt-killed %s.", vName)
                          spec_weap = true
                        }
                        case 24: //Demo Axe Taunt
                        {
                          num_drinks+=3;
                          Format(vMessage, sizeof(vMessage), "\x04%s taunt-killed you.", aName)
                          Format(aMessage, sizeof(aMessage), "\x04You taunt-killed %s.", vName)
                          spec_weap = true
                        }
                        case 29: //Medic Ubersaw Taunt
                        {
                          num_drinks+=3;
                          Format(vMessage, sizeof(vMessage), "\x04%s taunt-killed you.", aName)
                          Format(aMessage, sizeof(aMessage), "\x04You taunt-killed %s.", vName)
                          spec_weap = true
                        }
                        case 33: //Engineer smash
                        {
                          num_drinks+=3;
                          Format(vMessage, sizeof(vMessage), "\x04%s taunt-killed you.", aName)
                          Format(aMessage, sizeof(aMessage), "\x04You taunt-killed %s.", vName)
                          spec_weap = true
                        }
                        case 38: //Engineer Robo-Arm Taunt
                        {
                          num_drinks+=3;
                          Format(vMessage, sizeof(vMessage), "\x04%s taunt-killed you.", aName)
                          Format(aMessage, sizeof(aMessage), "\x04You taunt-killed %s.", vName)
                          spec_weap = true
                        }
                    }
                    //Step 2.2.2: Specific weapon checks
                    if(strcmp(weapon,"deflect_rocket",false)==0)
                    {
                        num_drinks+=2;
                        Format(vMessage, sizeof(vMessage), "\x04%s killed you with an airblast.", aName)
                        Format(aMessage, sizeof(aMessage), "\x04You killed %s with an airblast.", vName)
                        spec_weap = true
                    } else if(strcmp(weapon,"sledgehammer",false)==0)
                    {
                        num_drinks+=2;
                        Format(vMessage, sizeof(vMessage), "\x04%s killed you with the homewrecker.", aName)
                        Format(aMessage, sizeof(aMessage), "\x04You killed %s with the homewrecker.", vName)
                        spec_weap = true
                    } else if(strcmp(weapon,"huntsman",false)==0)
                    {
                        if(cust_kill==1) //Headshot
                        {
                          num_drinks+=2;
                          Format(vMessage, sizeof(vMessage), "\x04%s killed you with a headshot from the huntsman.", aName)
                          Format(aMessage, sizeof(aMessage), "\x04You killed %s with a headshot from the huntsman.", vName)
                          spec_weap = true
                        }
                    } else if(strcmp(weapon,"syringegun_medic",false)==0)
                    {
                        num_drinks+=2;
                        Format(vMessage, sizeof(vMessage), "\x04%s killed you with the syringe gun.", aName)
                        Format(aMessage, sizeof(aMessage), "\x04You killed %s with the syringe gun.", vName)
                        spec_weap = true
                    } else if(strcmp(weapon,"robot_arm_kill",false)==0)
                    {
                        num_drinks+=2;
                        Format(vMessage, sizeof(vMessage), "\x04%s killed you with the gunslinger.", aName)
                        Format(aMessage, sizeof(aMessage), "\x04You killed %s with the gunslinger.", vName)
                        spec_weap = true
                    } else if(strcmp(weapon,"holy_mackerel",false)==0)
                    {
                        num_drinks+=2;
                        Format(vMessage, sizeof(vMessage), "\x04%s killed you with the fish.", aName)
                        Format(aMessage, sizeof(aMessage), "\x04You killed %s with the fish.", vName)
                        spec_weap = true
                    } else if(strcmp(weapon,"ball",false)==0)
                    {
                        PrintToChatAll("\x04%s killed %s with the sandman ball! What was %s doing with so little HP? %s must FINISH. HIS. DRINK.\x01", aName, vName, vName, vName)
                    }
                    //Step 2.2.3: Normal Kill, non-advanced weapon rule
                    if(!spec_weap)
                    {
                        num_drinks++;
                        Format(vMessage, sizeof(vMessage), "\x04%s killed you.", aName)
                        Format(aMessage, sizeof(aMessage), "\x04You killed %s.", vName)
                    }
                 }
                 //Step 2.3: Assist Analysis
                 if(assister!=-1)
                 {
                    if(CheckName(sName)!=0)
                    {
                        if(!feign)
                        {
                            PrintToChat(victim, "\x04%s assisted against you. Take 1 drinks.\x01", sName)
                        }
                        PrintToChat(assister, "\x04You assisted against %s. They take 1 drinks.\x01", vName)
                        //PrintToChat(attacker, "\x04%s assisted you against %s, so %s takes 1 additional drinks.\x01", sName, vName, vName)
                    }
                 }
              }
            }
            if(num_drinks>0)
            {
              new String:temp[2]
              IntToString(num_drinks,temp,2)
              if(!feign)
              {
                 StrCat(vMessage, sizeof(vMessage), " Take ")
                 StrCat(vMessage, sizeof(vMessage), temp)
                 StrCat(vMessage, sizeof(vMessage), " drinks.\x01")
                 PrintToChat(victim, vMessage)
              }
              if(attacker!=0)
              {
                 StrCat(aMessage, sizeof(aMessage), " They take ")
                 StrCat(aMessage, sizeof(aMessage), temp)
                 StrCat(aMessage, sizeof(aMessage), " drinks.\x01")
                 PrintToChat(attacker, aMessage)
              }
            }
        }

        public Basic_Rules(Handle:event)
        {
            new victim = GetClientOfUserId(GetEventInt(event, "userid"))
            new attacker = GetClientOfUserId(GetEventInt(event, "attacker"))
            new assister = GetClientOfUserId(GetEventInt(event, "assister"))
            new String:aName[128]
            new String:vName[128]
            new String:sName[128]
            new String:weapon[128]
            GetClientName(victim,vName,128)
            GetClientName(attacker,aName,128)
            GetClientName(assister,sName,128)
            new aDrink = CheckName(aName)
            GetEventString(event, "weapon", weapon, 128)
            new df = GetEventInt(event, "death_flags")
            new bool:feign = false
            new String:vMessage[512]
            new String:aMessage[512]
            new num_drinks = 0
            //Step 1: World Deaths
            new wd = isWorldDeath(event, attacker, weapon, aDrink)
            switch (wd)
            {
              case 1:
              {
                 num_drinks++;
                 StrCat(vMessage, 512, "\x04You died to the world.")
              }
              case 2:
              {
                 num_drinks+=2;
                 Format(vMessage, sizeof(vMessage), "\x04%s got an environment kill on you.", aName)
                 Format(aMessage, sizeof(aMessage), "\x04You got an environment kill on %s.", vName)
              }
              case 3:
              {
                 num_drinks+=3;
                 Format(vMessage, sizeof(vMessage), "\x04%s got an environment kill on you, and is also playing the drinking game.", aName)
                 Format(aMessage, sizeof(aMessage), "\x04You got an environment kill on %s, and you are also playing the drinking game.", vName)
              }
            }
            //Step 2: Analysis of standard (non-environment) death
            if(wd==0)
            {
              if(victim!=attacker) //Avoids a bug with sm_slay
              {
                 if(df&32)
                 {
                    feign = true
                 }
                 //Step 2.1: Domination/Revenge code
                 if(df&1||df&2) //Did the attacker get a domination?
                 {
                    num_drinks+=2;
                    Format(vMessage, sizeof(vMessage), "\x04%s killed you, and dominated you.", aName)
                    Format(aMessage, sizeof(aMessage), "\x04You killed %s, and dominated them.", vName)
                 }
                 else if(df&4||df&8) //Did the attacker get a revenge?
                 {
                    num_drinks+=2;
                    Format(vMessage, sizeof(vMessage), "\x04%s killed you, and got a revenge on you.", aName)
                    Format(aMessage, sizeof(aMessage), "\x04You killed %s, and got a revenge on them.", vName)
                 }
                 //Step 2.2: Normal Kill
                 else
                 {
                    num_drinks++;
                    Format(vMessage, sizeof(vMessage), "\x04%s killed you.", aName)
                    Format(aMessage, sizeof(aMessage), "\x04You killed %s.", vName)
                 }
                 //Step 2.3: Assist Analysis
                 if(assister!=-1)
                 {
                    if(CheckName(sName)!=0)
                    {
                        if(!feign)
                        {
                            PrintToChat(victim, "\x04%s assisted against you. Take 1 drinks.\x01", sName)
                        }
                        PrintToChat(assister, "\x04You assisted against %s. They take 1 drink1.\x01", vName)
                        //PrintToChat(attacker, "\x04%s assisted you against %s, so %s takes 1 additional drinks.\x01", sName, vName, vName)
                    }
                 }
              }
            }
            if(num_drinks>0)
            {
              new String:temp[2]
              IntToString(num_drinks,temp,2)
              if(!feign)
              {
                 StrCat(vMessage, sizeof(vMessage), " Take ")
                 StrCat(vMessage, sizeof(vMessage), temp)
                 StrCat(vMessage, sizeof(vMessage), " drinks.\x01")
                 PrintToChat(victim, vMessage)
              }
              if(attacker!=0)
              {
                 StrCat(aMessage, sizeof(aMessage), " They take ")
                 StrCat(aMessage, sizeof(aMessage), temp)
                 StrCat(aMessage, sizeof(aMessage), " drinks.\x01")
                 PrintToChat(attacker, aMessage)
              }
            }
        }

        public Event_Death(Handle:event, const String:name[], bool:dontBroadcast)
        {
            new victim = GetClientOfUserId(GetEventInt(event, "userid"))
            new attacker = GetClientOfUserId(GetEventInt(event, "attacker"))
            new String:vName[128]
            new String:aName[128]
            GetClientName(victim,vName,128)
            GetClientName(attacker,aName,128)
            new vDrink = CheckName(vName)
            new aDrink = CheckName(aName)
            switch (vDrink)
            {
            case 3: //Victim is playing advanced rules AND wants notification to drink on all deaths.
            {
               Adv_Rules(event)
            }
              case 2: //Victim is playing advanced rules, only notify of death if the other person is playing
              {
                if(aDrink!=0)
               {
                 Adv_Rules(event)
               }
              }
              case 1: //Victim is playing basic rules, only notify of death if the other person is playing
              {
               if(aDrink!=0)
               {
                 Basic_Rules(event)
               }
              }
              case 0: //Victim is not playing
              {
                 //Do nothing
              }
            }
        }

        //Helper functions

        public isWorldDeath(Handle:event, attacker, String:weapon[], aDrink)
        {
            //Preconditions: event is valid in context, attacker is a client ID of the attacker, wep_id is the weapon that killed the player, aDrink is a result from CheckName for attacker
            //Postconditions: None
            //Purpose: isWorldDeath handles the determination on if the player died to the world, and if so, whether it was player assisted. It returns a numerical value signifying the number
            //of drinks the victim must have.
            if(attacker==0) //World death without player assistance
            {
              return 1
            }
            //else if(strcmp(weapon, "world", false)==0&&attacker!=GetClientOfUserId(GetEventInt(event, "attacker"))) //Player 'wields' world to kill someone. However, suicide is a 'world' kill as well.
            else if(strcmp(weapon, "world", false)==0)
            {
              if(aDrink!=0) //Is the attacker playing? It's worth another drink
              {
                 return 3
              }
              else
              {
                 return 2
              }
            }
            else
            {
              return 0
            }
        }

        public CheckName(String:name[])
        {
            //Preconditions: name is at least two characters long
            //Postconditions: None
            //Purpose: CheckName accepts a playername as a string, and determines if the end of the name contains an asterisk. If it does,
            //it checks to see if there's another asterisk. If so, it returns 2, signalling advanced rules. If not, it returns 1, signalling
            //basic rules. Otherwise, it returns 0, signallying that the name in question is not playing the drinking game.
            new size = strlen(name)
            if(size>=2)
            {
              if(name[size-1]=='*')
              {
                 if(name[size-2]=='*')
                 {
                 if(name[size-3]=='*')
                 {
                    return 3
                 }
                 else
                 {
                    return 2
                 }
                 }
                 else
                 {
                    return 1
                 }
              }
              else
              {
                 return 0
              }
            }
            else
            {
              return 0
            }
        }

        public NotifyAllDrinkers(num_drinks, String:message[])
        {
            //Preconditions: num_drinks is a number, message is not null
            //Postconditions: None
            //Purpose: NotifyAllDrinkers is currently only used when a player who is playing the drinking game gets an achievement. When that occurs,
            //it sends a message to all other players in the server who are playing the game to take a drink, and why. However, it is general enough
            //that you can use it for other needs.
            new String:vName[128]
            for (new i = 1; i <= MaxClients; i++)
            {
                if (IsClientInGame(i))
                {
                 GetClientName(i,vName,128)
                 new isDrink = CheckName(vName)
                 if(isDrink!=0)
                 {
                    PrintToChat(i, "\x04%s Take %i drinks!\x01", message, num_drinks)
                 }
                }
            }
        }

        public NotifyTeamDrinkers(num_drinks, String:message[], teamNum, bool:win)
        {
            //Preconditions: num_drinks is a number, message is not null, teamNum is a number, win is either true or false
            //Postconditions: None
            //Purpose: NotifyTeamDrinkers is utilized when a round is completed. It will send a message to all players on a specified team (2 for red, 3
            //for blue) who are playing the game. Depending on which value the variable win is set to, the team will either be notified that they forced
            //the other team to take the drinks or they themselves need to.
            new String:vName[128]
            for (new i = 1; i <= MaxClients; i++)
            {
                if (IsClientInGame(i))
                {
                 GetClientName(i,vName,128)
                 new isDrink = CheckName(vName)
                 if(isDrink!=0)
                 {
                    if (GetClientTeam(i)==teamNum)
                    {
                        if(win)
                        {
                          PrintToChat(i, "\x04%s The other team has to take %i drinks!\x01", message, num_drinks)
                        }
                        else
                        {
                          PrintToChat(i, "\x04%s Take %i drinks!\x01", message, num_drinks)
                        }
                    }
                 }
              }
            }
        }