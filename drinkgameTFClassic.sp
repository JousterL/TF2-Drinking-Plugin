            #include <sourcemod>
            #include <sdktools>
            #include <tf2>
            #include <tf2_stocks>
            #include <colors>
            #undef REQUIRE_EXTENSIONS

            #define SOUND "vo/burp02.wav"
            public Plugin:myinfo =
            {
                name = "The Furry Pound Drinking Game",
                author = "JousterL",
                description = "Automated notification of drinking events",
                version = "1.3.0.1",
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
           
            public OnMapStart()
            {
                PrecacheSound(SOUND);
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
                if(CheckName(rName)==2||CheckName(rName)==3)
                {
                  CPrintToChat(rec, "\x04Toast the heavy, %s, who gave you his sandvich for your life. Enjoy a drink.\x01", gName)
                  if(CheckName(gName)==2||CheckName(gName)==3)
                  {
                     CPrintToChat(giv, "\x04You saved %s with that sandvich. They toast your good health with a drink. Consider having one yourself.\x01", rName)
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
                  if(CheckName(vName)>1)
                  {
                     EmitSoundToClient(victim, SOUND)
                     CPrintToChat(victim, "{red}%s stunned you with the sandman. Take a drink.{default}", aName)
                     if(CheckName(aName)>3)
                     {
                         CPrintToChat(attacker, "{blue}You stunned %s with the sandman. They take a drink. Take a drink as well.{default}", vName)
                     }
                     else
                     {
                        CPrintToChat(attacker, "{green}You stunned %s with the sandman. They take a drink.{default}", vName)
                     }
                  }
                }
            }

            public Notify(Handle:event, const String:name[], bool:dontBroadcast)
            {
                new cl = GetClientOfUserId(GetEventInt(event, "userid"))
                new String:temp[128]
                GetEventString(event, "newname", temp, 128)
                new isDrink = CheckName(temp)
                if(isDrink==4)
                {
                    CPrintToChat(cl, "{olive}Due to the structure of your name you have been flagged as participating in NikkyVix's Suicide Cirrhosis Mode, and will play Extreme mode and receive a drink when you give a drink.{default}")
                }
                if(isDrink==3)
                {
                    CPrintToChat(cl, "{blue}Due to the structure of your name you have been flagged as participating in the Extreme Rules of the TFP drinking game, and will receive a notice every time someone kills you.{default}")
                }
                if(isDrink==2)
                {
                    CPrintToChat(cl, "{red}Due to the structure of your name you have been flagged as participating in the Advanced Rules of the TFP drinking game, and will receive more notices on when to take a drink.{default}")
                }
                if(isDrink==1)
                {
                    CPrintToChat(cl, "{green}Due to the structure of your name you have been flagged as participating in the TFP drinking game, and will receive notices on when to take a drink.{default}")
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
                    if(isDrink==4)
                    {
                        CPrintToChat(cl, "{olive}Due to the structure of your name you have been flagged as participating in NikkyVix's Suicide Cirrhosis Mode, and will play Extreme mode and receive a drink when you give a drink.{default}")
                    }
                    if(isDrink==3)
                    {
                        CPrintToChat(cl, "{blue}Due to the structure of your name you have been flagged as participating in the Extreme Rules of the TFP drinking game, and will receive a notice every time someone kills you.{default}")
                    }
                    if(isDrink==2)
                    {
                        CPrintToChat(cl, "{red}Due to the structure of your name you have been flagged as participating in the Advanced Rules of the TFP drinking game, and will receive more notices on when to take a drink.{default}")
                    }
                    if(isDrink==1)
                    {
                        CPrintToChat(cl, "{green}Due to the structure of your name you have been flagged as participating in the TFP drinking game, and will receive notices on when to take a drink.{default}")
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
                if(isDrink>0)
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
                if(isDrink>0)
                {
                  CPrintToChat(victim_id, "{red}Ouch, autobalanced. Have a drink for your sorrows.{default}");
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
                new penetrate = GetEventInt(event, "playerpenetratecount")
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
                       StrCat(vMessage, 512, "{red}You died to the world.")
                    }
                    case 2:
                    {
                       num_drinks+=2;
                       Format(vMessage, sizeof(vMessage), "{red}%s got an environment kill on you.", aName)
                       Format(aMessage, sizeof(aMessage), "{green}You got an environment kill on %s.", vName)
                    }
                    case 3:
                    {
                       num_drinks+=3;
                       Format(vMessage, sizeof(vMessage), "{red}%s got an environment kill on you, and is also playing the drinking game.", aName)
                       Format(aMessage, sizeof(aMessage), "{green}You got an environment kill on %s, and you are also playing the drinking game.", vName)
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
                           Format(vMessage, sizeof(vMessage), "{red}%s killed you, and dominated you.", aName)
                           Format(aMessage, sizeof(aMessage), "{green}You killed %s, and dominated them.", vName)
                        }
                        else if(df&4||df&8) //Did the attacker get a revenge?
                        {
                           num_drinks+=2;
                           Format(vMessage, sizeof(vMessage), "{red}%s killed you, and got a revenge on you.", aName)
                           Format(aMessage, sizeof(aMessage), "{green}You killed %s, and got a revenge on them.", vName)
                        }
                        //Step 2.2: Normal Kill, detect if weapon was one in Advanced Rules.
                        switch(cust_kill) //Step 2.2.1: Taunt detection
                        {
                           case 7: //Pyro Hadouken Taunt
                            {
                                num_drinks+=3;
                                Format(vMessage, sizeof(vMessage), "{red}%s taunt-killed you.", aName)
                                Format(aMessage, sizeof(aMessage), "{green}You taunt-killed %s.", vName)
                                spec_weap = true
                            }
                            case 9: //High noon
                            {
                                num_drinks+=3;
                                Format(vMessage, sizeof(vMessage), "{red}%s taunt-killed you.", aName)
                                Format(aMessage, sizeof(aMessage), "{green}You taunt-killed %s.", vName)
                                spec_weap = true
                            }
                            case 10: //Grand slam
                            {
                                num_drinks+=3;
                                Format(vMessage, sizeof(vMessage), "{red}%s taunt-killed you.", aName)
                                Format(aMessage, sizeof(aMessage), "{green}You taunt-killed %s.", vName)
                                spec_weap = true
                            }
                            case 13: //Spy Fencing Taunt
                            {
                                num_drinks+=3;
                                Format(vMessage, sizeof(vMessage), "{red}%s taunt-killed you.", aName)
                                Format(aMessage, sizeof(aMessage), "{green}You taunt-killed %s.", vName)
                                spec_weap = true
                            }
                            case 15: //Sniper Arrow Taunt
                            {
                                num_drinks+=3;
                                Format(vMessage, sizeof(vMessage), "{red}%s taunt-killed you.", aName)
                                Format(aMessage, sizeof(aMessage), "{green}You taunt-killed %s.", vName)
                                spec_weap = true
                            }
                            case 21: //Soldier Grenade Taunt
                            {
                                num_drinks+=3;
                                Format(vMessage, sizeof(vMessage), "{red}%s taunt-killed you.", aName)
                                Format(aMessage, sizeof(aMessage), "{green}You taunt-killed %s.", vName)
                                spec_weap = true
                            }
                            case 24: //Demo Axe Taunt
                            {
                                num_drinks+=3;
                                Format(vMessage, sizeof(vMessage), "{red}%s taunt-killed you.", aName)
                                Format(aMessage, sizeof(aMessage), "{green}You taunt-killed %s.", vName)
                                spec_weap = true
                            }
                            case 29: //Medic Ubersaw Taunt
                            {
                                num_drinks+=3;
                                Format(vMessage, sizeof(vMessage), "{red]%s taunt-killed you.", aName)
                                Format(aMessage, sizeof(aMessage), "{green}You taunt-killed %s.", vName)
                                spec_weap = true
                            }
                            case 33: //Engineer smash
                            {
                                num_drinks+=3;
                                Format(vMessage, sizeof(vMessage), "{red}%s taunt-killed you.", aName)
                                Format(aMessage, sizeof(aMessage), "{green}You taunt-killed %s.", vName)
                                spec_weap = true
                            }
                            case 38: //Engineer Robo-Arm Taunt
                            {
                                num_drinks+=3;
                                Format(vMessage, sizeof(vMessage), "{red}%s taunt-killed you.", aName)
                                Format(aMessage, sizeof(aMessage), "{green}You taunt-killed %s.", vName)
                                spec_weap = true
                            }
                        }
                        //Step 2.2.2: Specific weapon checks
                        if(strcmp(weapon,"deflect_rocket",false)==0)
                        {
                            num_drinks+=2;
                            Format(vMessage, sizeof(vMessage), "{red}%s killed you with an airblast.", aName)
                            Format(aMessage, sizeof(aMessage), "{green}You killed %s with an airblast.", vName)
                            spec_weap = true
                        } else if(strcmp(weapon,"sledgehammer",false)==0)
                        {
                            num_drinks+=2;
                            Format(vMessage, sizeof(vMessage), "{red}%s killed you with the homewrecker.", aName)
                            Format(aMessage, sizeof(aMessage), "{green}You killed %s with the homewrecker.", vName)
                            spec_weap = true
                        } else if(strcmp(weapon,"huntsman",false)==0)
                        {
                            if(cust_kill==1) //Headshot
                            {
                                num_drinks+=2;
                                Format(vMessage, sizeof(vMessage), "{red}%s killed you with a headshot from the huntsman.", aName)
                                Format(aMessage, sizeof(aMessage), "{green}You killed %s with a headshot from the huntsman.", vName)
                                spec_weap = true
                            }
                        } else if(strcmp(weapon,"syringegun_medic",false)==0)
                        {
                            num_drinks+=2;
                            Format(vMessage, sizeof(vMessage), "{red}%s killed you with the syringe gun.", aName)
                            Format(aMessage, sizeof(aMessage), "{green}You killed %s with the syringe gun.", vName)
                            spec_weap = true
                        } else if(strcmp(weapon,"robot_arm_kill",false)==0)
                        {
                            num_drinks+=2;
                            Format(vMessage, sizeof(vMessage), "{red}%s killed you with the gunslinger.", aName)
                            Format(aMessage, sizeof(aMessage), "{green}You killed %s with the gunslinger.", vName)
                            spec_weap = true
                        } else if(strcmp(weapon,"holy_mackerel",false)==0)
                        {
                            num_drinks+=2;
                            Format(vMessage, sizeof(vMessage), "{red}%s killed you with the fish.", aName)
                            Format(aMessage, sizeof(aMessage), "{green}You killed %s with the fish.", vName)
                            spec_weap = true
                        } else if(strcmp(weapon,"ball",false)==0)
                        {
                            CPrintToChatAll("{olive}%s killed %s with the sandman ball! What was %s doing with so little HP? %s must FINISH. THEIR. DRINK.{default}", aName, vName, vName, vName)
                            if(CheckName(aName)==4)
                            {
                                CPrintToChatAll("{olive}Double Drink All The Way Across The Server! %s was playing Suicide Cirrhosis mode! %s must FINISH. THEIR. DRINK. AS. WELL!{default}", aName, aName);
                            }
                        } else if(strcmp(weapon,"player_penetration",false)==0)
                        {
                            switch(penetrate)
                            {
                                case 1:
                                {
                                    new String:temp[256]
                                    Format(temp, sizeof(temp), "{red}%s penetrated 1 person!", aName)
                                    NotifyAllDrinkers(2, temp)
                                }
                                case 2:
                                {
                                    new String:temp[256]
                                    Format(temp, sizeof(temp), "{green}%s penetrated 2 people!", aName)
                                    NotifyAllDrinkers(4, temp)
                                }
                                default:
                                {
                                    new String:temp[256]
                                    Format(temp, sizeof(temp), "{blue}%s penetrated %i people!", aName, penetrate)
                                    NotifyAllDrinkers(999, temp) //999 is a sentinel value to tell NotifyAllDrinkers to finish drinks.
                                }
                            }
                   } else
                   {
                            //Step 2.2.3: Normal Kill, non-advanced weapon rule
                            if(!spec_weap)
                            {
                                //Step 2.2.3.1: Uber Analysis
                                if(TF2_GetPlayerClass(victim) == TF2_GetClass("medic"))
                                {
                                    if(GetUber(victim)==100)
                                    {
                                        num_drinks+=4;
                                        Format(vMessage, sizeof(vMessage), "{red}%s killed you, and you had a full uber.", aName)
                                        Format(aMessage, sizeof(aMessage), "{green}You killed %s, and they had a full uber.", vName)
                                    }
                                } else
                                {
                                    num_drinks++;
                                    Format(vMessage, sizeof(vMessage), "{red}%s killed you.", aName)
                                    Format(aMessage, sizeof(aMessage), "{green}You killed %s.", vName)
                                }
                            }
                        }
                    //Step 2.3: Assist Analysis
                        if(assister!=-1)
                        {
                            if(CheckName(sName)!=0)
                            {
                                if(!feign)
                                {
                                    CPrintToChat(victim, "{red}%s assisted against you. Take 1 drinks.{default}", sName)
                                }
                                if(CheckName(sName)==4)
                                {
                                    CPrintToChat(assister, "{blue}You assisted against %s. They take 1 drink. You take 1 drink as well.{default}", vName)
                                }
                                else
                                {
                                    CPrintToChat(assister, "{green}You assisted against %s. They take 1 drinks.{default}", vName)
                                }
                                //CPrintToChat(attacker, "\x04%s assisted you against %s, so %s takes 1 additional drinks.{default}", sName, vName, vName)
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
                     StrCat(vMessage, sizeof(vMessage), " drinks.{default}")
                     EmitSoundToClient(victim, SOUND)
                     CPrintToChat(victim, vMessage)
                  }
                  if(attacker!=0)
                  {
                     StrCat(aMessage, sizeof(aMessage), " They take ")
                     StrCat(aMessage, sizeof(aMessage), temp)
                     StrCat(aMessage, sizeof(aMessage), " drinks.{default}")
                     if(CheckName(aName)==4)
                     {
                        StrCat(aMessage, sizeof(aMessage), " Take ")
                        StrCat(aMessage, sizeof(aMessage), temp)
                        StrCat(aMessage, sizeof(aMessage), " drinks as well.{default}")
                     }
                     CPrintToChat(attacker, aMessage)
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
                     StrCat(vMessage, 512, "{red}You died to the world.")
                  }
                  case 2:
                  {
                     num_drinks+=2;
                     Format(vMessage, sizeof(vMessage), "{red}%s got an environment kill on you.", aName)
                     Format(aMessage, sizeof(aMessage), "{green}You got an environment kill on %s.", vName)
                  }
                  case 3:
                  {
                     num_drinks+=3;
                     Format(vMessage, sizeof(vMessage), "{red}%s got an environment kill on you, and is also playing the drinking game.", aName)
                     Format(aMessage, sizeof(aMessage), "{green}You got an environment kill on %s, and you are also playing the drinking game.", vName)
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
                        Format(vMessage, sizeof(vMessage), "{red}%s killed you, and dominated you.", aName)
                        Format(aMessage, sizeof(aMessage), "{green}You killed %s, and dominated them.", vName)
                     }
                     else if(df&4||df&8) //Did the attacker get a revenge?
                     {
                        num_drinks+=2;
                        Format(vMessage, sizeof(vMessage), "{red}%s killed you, and got a revenge on you.", aName)
                        Format(aMessage, sizeof(aMessage), "{green}You killed %s, and got a revenge on them.", vName)
                     }
                     //Step 2.2: Normal Kill
                     else
                     {
                        num_drinks++;
                        Format(vMessage, sizeof(vMessage), "{red}%s killed you.", aName)
                        Format(aMessage, sizeof(aMessage), "{green}You killed %s.", vName)
                     }
                     //Step 2.3: Assist Analysis
                     if(assister!=-1)
                     {
                        if(CheckName(sName)!=0)
                        {
                            if(!feign)
                            {
                                CPrintToChat(victim, "{red}%s assisted against you. Take 1 drinks.{default}", sName)
                            }
                            CPrintToChat(assister, "{green}You assisted against %s. They take 1 drink.{default}", vName)
                            //CPrintToChat(attacker, "\x04%s assisted you against %s, so %s takes 1 additional drinks.{default}", sName, vName, vName)
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
                     StrCat(vMessage, sizeof(vMessage), " drinks.{default}")
                     EmitSoundToClient(victim, SOUND)
                     CPrintToChat(victim, vMessage)
                  }
                  if(attacker!=0)
                  {
                     StrCat(aMessage, sizeof(aMessage), " They take ")
                     StrCat(aMessage, sizeof(aMessage), temp)
                     StrCat(aMessage, sizeof(aMessage), " drinks.{default}")
                     CPrintToChat(attacker, aMessage)
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
                    case 4: //Victim is playing Super rules, take a drink whenever you give a drink.
                    {
                        Adv_Rules(event)
                    }
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
                //it checks to see if there's another asterisk. 4 asterisks = Super Mode, 3 = Extreme Mode, 2 = Advanced rules, 1 = Basic rules.
                new size = strlen(name)
                if(size>=2)
                {
                  if(name[size-1]=='*')
                  {
                     if(name[size-2]=='*')
                     {
                        if(name[size-3]=='*')
                        {
                            if(name[size-4]=='*')
                            {
                                return 4
                            }
                            else
                            {
                                return 3
                            }
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
                        EmitSoundToClient(i, SOUND)
                        if(num_drinks==999)
                        {
                            CPrintToChat(i, "{red}%s Finish your drink!{default}", message)
                        } else
                        {
                            CPrintToChat(i, "{red}%s Take %i drinks!{default}", message, num_drinks)
                        }
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
                              CPrintToChat(i, "{green}%s The other team has to take %i drinks!{default}", message, num_drinks)
                            }
                            else
                            {
                              EmitSoundToClient(i, SOUND)
                              CPrintToChat(i, "{red}%s Take %i drinks!{default}", message, num_drinks)
                            }
                        }
                     }
                  }
                }
            }
           
            public GetUber(client)
            {
                new ind = GetPlayerWeaponSlot(client, 1);
                if(ind>0)
                {
                    return RoundFloat(GetEntPropFloat(ind, Prop_Send, "m_flChargeLevel")*100)
                }
                else
                {
                    return 0;
                }
            }
