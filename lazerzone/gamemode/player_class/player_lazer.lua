-- Lazer Zone by daunknownfox2010

AddCSLuaFile();


if ( CLIENT ) then

	CreateConVar( "cl_playerskin", 0, { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The skin to use, if the model has any" );
	CreateConVar( "cl_playerbodygroups", 0, { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The bodygroups to use, if the model has any" );

end


local PLAYER = {};

PLAYER.DisplayName = "Lazer Player";

PLAYER.WalkSpeed = 190;
PLAYER.RunSpeed = 320;
PLAYER.CrouchedWalkSpeed = 0.3;
PLAYER.DuckSpeed = 0.3;
PLAYER.UnDuckSpeed = 0.3;
PLAYER.JumpPower = 0;
PLAYER.CanUseFlashlight = false;
PLAYER.MaxHealth = 100;
PLAYER.StartHealth = 100;
PLAYER.StartArmor = 0;
PLAYER.DropWeaponOnDie = false;
PLAYER.TeammateNoCollide = false;
PLAYER.AvoidPlayers = false;
PLAYER.UseVMHands = true;


function PLAYER:Loadout()
end


function PLAYER:SetModel()
end


player_manager.RegisterClass( "player_lazer", PLAYER, "player_default" );
