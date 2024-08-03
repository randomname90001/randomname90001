/*

    This replaces the Crusader's Crossbow, just execute this script and equip it to use this.

*/

// Just prints debuff duration and what not at the moment.
::DEBUG <- false

::TF_CLASS_SCOUT 	<- 1
::TF_CLASS_SNIPER 	<- 2
::TF_CLASS_SOLDIER 	<- 3
::TF_CLASS_DEMOMAN 	<- 4
::TF_CLASS_MEDIC 	<- 5
::TF_CLASS_HEAVY 	<- 6
::TF_CLASS_PYRO 	<- 7
::TF_CLASS_SPY 		<- 8
::TF_CLASS_ENGINEER <- 9

::TF_SLOT_PRIMARY 	<- 0
::TF_SLOT_SECONDARY <- 1
::TF_SLOT_MELEE 	<- 2
::TF_SLOT_PDA 		<- 3

::TF_AMMO_DUMMY 	<- 0
::TF_AMMO_PRIMARY 	<- 1
::TF_AMMO_SECONDARY <- 2
::TF_AMMO_METAL 	<- 3
::TF_AMMO_GRENADES1	<- 4
::TF_AMMO_GRENADES2 <- 5
::TF_AMMO_GRENADES3 <- 6

::TF_CRIT_IGNORE	<- -1
::TF_CRIT_NONE 		<- 0
::TF_CRIT_MINI		<- 1
::TF_CRIT_FULL		<- 2

::DMG_CRIT <- 1048576
::DMG_MINICRIT <- 1024
::DMG_FALLOFF <- 2097152

::DMG_CUSTOM_NONE <- 0
::DMG_CUSTOM_HEADSHOT <- 1

// This is a bit wonky, and isn't accurate to the power charge meter in the scope.
::TF_SNIPER_RIFLE_HEADSHOT_PERCENT <- 0.55

::TF_SNIPER_RIFLE_CHARGE_RATE <- 2.0
::TF_SNIPER_RIFLE_CHARGE_NERF <- TF_SNIPER_RIFLE_CHARGE_RATE / 4.0
::TF_SNIPER_RIFLE_CLIP_SIZE <- 16.0 / 25.0
::TF_SNIPER_RIFLE_BODYSHOT_MAX <- 125.0

::TF_WEAPON_SMG <- "tf_weapon_smg"
::TF_WEAPON_CROSSBOW <- "tf_weapon_crossbow"

::TF_SMG_CLIP_SIZE <- 30.0 / 25.0
::TF_SMG_RESERVE_SIZE <- 90.0 / 75.0

::TF_CLASS_SPEED <-
[
	0.0,
	400.0,
	300.0,
	240.0,
	280.0,
	320.0,
	230.0,
	300.0,
	320.0,
	300.0,
];

::TF_COND_DISGUISED <- 3
::TF_COND_MARKEDFORDEATH <- 30

::TF_STUN_BASE <- 450.0

::TF_STUN_NONE <- 0
::TF_STUN_MOVEMENT <- (1 << 0)
::TF_STUN_CONTROLS <- (1 << 1)
::TF_STUN_MOVEMENT_FORWARD_ONLY <- (1 << 2)
::TF_STUN_SPECIAL_SOUND <- (1 << 3)
::TF_STUN_DODGE_COOLDOWN <- (1 << 4)
::TF_STUN_NO_EFFECTS <- (1 << 5)
::TF_STUN_LOSER_STATE <- (1 << 6)
::TF_STUN_BY_TRIGGER <- (1 << 7)
::TF_STUN_BOTH <- (1 << 8)

// Custom weapon modes
::TF_CROSSBOW_MARK <- 1

// Holds some custom props
::CustomWeaponTable <- {}

::min <- function(x, y)
{
    if (x < y)
    {
        return x
    } else
    {
        return y
    }
}

::max <- function(x, y)
{
    if (x > y)
    {
        return x
    } else
    {
        return y
    }
}

// We expect that y is lower than z
::clamp <- function(x, y, z)
{
    x = max(x, y)
    x = min(x, z)

    return x;
}

::RemapValClamped <- function(flBase, a, b, c, d)
{
    flBase = clamp(flBase, a, b)

    flBase -= a
    b -= a
    flBase /= b

    d -= c
    flBase *= d
    flBase += c

    return flBase;
}

class Cond
{
    constructor(Cond = 0, Duration = 0.0, Provider = null)
    {
        eCond = Cond
        flDuration = Duration
        hProvider = Provider
    }

    eCond = 0
    flDuration = 0.0
    hProvider = null

    function ApplyPlayer(hPlayer)
    {
        hPlayer.AddCondEx(eCond, flDuration, hProvider)
    }
}

// COMPLETELY UNDOCUMENTED, but weapons inherit from CTFWeaponBase, so add your functions to that.
::CTFWeaponBase.SetCustomProp <- function(szKey, ukValue)
{
    if (!(this in CustomWeaponTable))
        CustomWeaponTable[this] <- {}

    CustomWeaponTable[this][szKey] <- ukValue
}

::CTFWeaponBase.GetCustomProp <- function(szKey)
{
    if (!(this in CustomWeaponTable))
        return null;

    if (!(szKey in CustomWeaponTable[this]))
        return null;

    return CustomWeaponTable[this][szKey]
}

::CTFPlayer.SetCustomProp <- function(szKey, ukValue)
{
    if (!(this in CustomWeaponTable))
        CustomWeaponTable[this] <- {}

    CustomWeaponTable[this][szKey] <- ukValue
}

::CTFPlayer.GetCustomProp <- function(szKey)
{
    if (!(this in CustomWeaponTable))
        return null;

    if (!(szKey in CustomWeaponTable[this]))
        return null;

    return CustomWeaponTable[this][szKey]
}

::CTFPlayer.IsDisguised <- function()
{
    return this.InCond(TF_COND_DISGUISED)
}

::IsClassname <- function(hWeapon, szClassname)
{
    return hWeapon.GetClassname() == szClassname
}

::SetCustomWeaponMode <- function(hWeapon, iMode = 0)
{
    return hWeapon.AddAttribute("cannot delete", iMode, -1)
}

// We don't use "set_weapon_mode" because that screws with actual weapon functionality.
::GetCustomWeaponMode <- function(hWeapon)
{
    return hWeapon.GetAttribute("cannot delete", 0)
}


::CTFPlayer.GetWeaponBySlot <- function(iSlot)
{
	local weapon;
	for (local i = 0; i < 7; i++)
	{
		weapon = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		if (weapon != null && weapon.GetSlot() == iSlot)
			return weapon;
	}

	return null;
}

::CTFPlayer.SetReserveAmmo <- function(slot, amount)
{
	NetProps.SetPropIntArray(this, "m_iAmmo", amount, slot)
}

function OnScriptHook_OnTakeDamage(params)
{
    local hVictim = params.const_entity
    local hAttacker = params.attacker
    local hWeapon = params.weapon
    local flDamage = params.damage
    local fDamageType = params.damage_type
    local fDamageCustom = params.damage_stats
    local vDamageForce = params.damage_force
    local vDamagePosition = params.damage_position
    local flDistance;
    local bCrit = fDamageType & DMG_CRIT

    if (hWeapon)
    {
        if (IsClassname(hWeapon, TF_WEAPON_CROSSBOW) && GetCustomWeaponMode(hWeapon) == TF_CROSSBOW_MARK)
        {
	    // Disguised Spies are not affected.
            if (hVictim.IsDisguised() && hVictim.GetDisguiseTeam() == hAttacker.GetTeam())
                return;

            // Cloaked players are not affected.
            if (hVictim.IsFullyInvisible())
                return;
		
            local flDebuffDuration;
            local hLastHit = hWeapon.GetCustomProp("m_hLastHit")
            local flLastHitTime = hWeapon.GetCustomProp("m_flLastHitTime")

            // We only calculate distance if we need to.
            flDistance = hVictim.GetOrigin() - hAttacker.GetOrigin()
            flDistance = flDistance.Length()
            flDebuffDuration = RemapValClamped(flDistance, 768.0, 1536.0, 5.0, 0.0)

            // Full crits have extra duration like the old Sandman.
            if (bCrit)
                flDebuffDuration += 2.0

            // We have to "simulate" modified rampup because Huntsman bolts don't have that by default, and DMG_FALLOFF uses normal rampup.
            if (flDistance < 512.0)
                params.damage *= (75.0 * 1.2) / (75.0 * 1.5)

            params.damage_type = fDamageType | DMG_FALLOFF
            // We use normal arrows, and we don't want them doing headshots.
            if (fDamageCustom == DMG_CUSTOM_HEADSHOT && !hAttacker.IsCritBoosted())
                params.damage_type = fDamageType &~ DMG_CRIT

            // Give a condition to be applied in player_hurt.
            hVictim.SetCustomProp("m_hCondApply", Cond(TF_COND_MARKEDFORDEATH, flDebuffDuration, hAttacker))

            if (hLastHit && hLastHit != hVictim && flLastHitTime + 5.0 > Time())
                hLastHit.RemoveCondEx(TF_COND_MARKEDFORDEATH, true)

            hWeapon.SetCustomProp("m_hLastHit", hVictim)
            hWeapon.SetCustomProp("m_flLastHitTime", Time())

            if (DEBUG)
            {
                printl(format("Debuff Duration: %f", flDebuffDuration))
                printl(format("Distance: %f", flDistance))
            }

        }
    }

}

function OnGameEvent_player_hurt(params)
{
    local hVictim = GetPlayerFromUserID(params.userid)
    local hCond = hVictim.GetCustomProp("m_hCondApply")

    if (hCond)
    {
        hCond.ApplyPlayer(hVictim)
        hVictim.SetCustomProp("m_hCondApply", null)
    }
}

function OnGameEvent_post_inventory_application(params)
{
    local hPlayer = GetPlayerFromUserID(params.userid)

    if (hPlayer.GetPlayerClass() == TF_CLASS_MEDIC)
    {

        local hSyringe = hPlayer.GetWeaponBySlot(TF_SLOT_PRIMARY)

        if (IsClassname(hSyringe, TF_WEAPON_CROSSBOW))
        {
            SetCustomWeaponMode(hSyringe, TF_CROSSBOW_MARK)
            hSyringe.AddAttribute("no random crits", 0, -1)
            hSyringe.AddAttribute("max health additive penalty", -15, -1)
            hSyringe.AddAttribute("override projectile type", 8, -1)
            hSyringe.AddAttribute("damage penalty", 0.35, -1)
            hSyringe.AddAttribute("single wep holster time increased", 1.5, -1)
            hSyringe.AddAttribute("maxammo primary reduced", 0.13, -1)

            // Needed to remove marked for death.
            hSyringe.SetCustomProp("m_hLastHit", null)
            hSyringe.SetCustomProp("m_flLastHitTime", 0.0)

            hPlayer.SetReserveAmmo(TF_SLOT_PRIMARY, 20)
        }

    }

}

__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)

__CollectGameEventCallbacks(this)
