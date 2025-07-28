local hPlayer = GetListenServerHost();
local hThink;

if (hPlayer.ValidateScriptScope())
{
	hThink = hPlayer.GetScriptScope();
	hThink.bTaunting <- false;
	
	hThink["Think_Render"] <- function()
	{
		if (!hThink.bTaunting && !hPlayer.InCond(7))
			return -1;
				
		if (!hThink.bTaunting)
		{
			hThink.bTaunting = true;
			print("Taunt Duration: ");
			printl(hPlayer.GetTauntRemoveTime() - Time());
		}
	
		if (!hPlayer.InCond(7))	
		{
			hThink.bTaunting = false;
		}	

		return -1;
	}

	AddThinkToEnt(hPlayer, "Think_Render");
}
