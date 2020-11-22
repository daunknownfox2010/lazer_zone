-- Lazer Zone by daunknownfox2010

AddCSLuaFile();

include( "sh_sounds.lua" );
include( "sh_variables.lua" );
include( "player_meta.lua" );
include( "player_class/player_lazer.lua" );


-- Console Variables
local lz_sh_yellow_team_enabled = CreateConVar( "lz_sh_yellow_team_enabled", 1, { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "Include the Yellow team in the game." );


-- Global gamemode variables
GM.Name = "Lazer Zone";
GM.Author = "D4UNKNOWNFOX2010";
GM.Email = "N/A";
GM.Website = "https://daunknownfox2010.github.io/";
GM.Version = "rev. 4 (Public Alpha)";
GM.TeamBased = true;

GM.PlayerModels = {
	"models/player/Group01/female_01.mdl",
	"models/player/Group01/female_02.mdl",
	"models/player/Group01/female_03.mdl",
	"models/player/Group01/female_04.mdl",
	"models/player/Group01/female_05.mdl",
	"models/player/Group01/female_06.mdl",
	"models/player/Group01/male_01.mdl",
	"models/player/Group01/male_02.mdl",
	"models/player/Group01/male_03.mdl",
	"models/player/Group01/male_04.mdl",
	"models/player/Group01/male_05.mdl",
	"models/player/Group01/male_06.mdl",
	"models/player/Group01/male_07.mdl",
	"models/player/Group01/male_08.mdl",
	"models/player/Group01/male_09.mdl"
};


-- Create the teams
function GM:CreateTeams()

	TEAM_BLUE = 1;
	team.SetUp( TEAM_BLUE, "Blue Team", Color( 0, 100, 255 ) );
	team.SetSpawnPoint( TEAM_BLUE, { "info_player_combine", "info_player_counterterrorist" } );

	TEAM_RED = 2;
	team.SetUp( TEAM_RED, "Red Team", Color( 255, 50, 50 ) );
	team.SetSpawnPoint( TEAM_RED, { "info_player_rebel", "info_player_terrorist" } );

	TEAM_YELLOW = 3;
	team.SetUp( TEAM_YELLOW, "Yellow Team", Color( 255, 255, 0 ), ( !LZDisableYellowTeam && lz_sh_yellow_team_enabled:GetBool() ) );
	team.SetSpawnPoint( TEAM_YELLOW, { "info_player_start", "info_player_deathmatch" } );

	team.SetSpawnPoint( TEAM_SPECTATOR, "worldspawn" );

end


-- Custom collisions
function GM:ShouldCollide( entA, entB )

	-- Player collisions
	if ( IsValid( entA ) && entA:IsPlayer() && IsValid( entB ) && entB:IsPlayer() ) then
	
		return false;
	
	end

	return true;

end


-- Called after the player's think
function GM:PlayerPostThink( ply )

	if ( CLIENT ) then
	
		-- Dynamic lights
		if ( ply:Alive() && !ply:Deactivated() && !ply:HasStatusEffect( STATUS_INVISIBLE ) && !ply:IsSpectating() && ( ply == LocalPlayer() ) ) then
		
			local dlight = DynamicLight( ply:EntIndex() );
			if ( dlight ) then
			
				local vPos = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_Spine" ) || 0 );
			
				dlight.Pos = vPos;
				dlight.r = ply:GetPlayerColorStructure().r / 255 * 128;
				dlight.g = ply:GetPlayerColorStructure().g / 255 * 128;
				dlight.b = ply:GetPlayerColorStructure().b / 255 * 128;
				dlight.Brightness = 0.1;
				dlight.Size = 128;
				dlight.DieTime = CurTime() + 0.02;
				dlight.Decay = 512;
			
			end
		
		end
	
	end

	if ( SERVER ) then
	
		-- Player Stamina
		if ( !ply:IsSpectating() && ( ply:Stamina() > 0 ) && ply:KeyDown( IN_SPEED ) && ( ply:GetVelocity():Length() > ply:GetWalkSpeed() ) ) then
		
			ply:SetStamina( ply:Stamina() - 0.5 );
		
			if ( ply:Stamina() < 0 ) then
			
				ply:SetStamina( 0 );
			
			end
		
		elseif ( ply:Stamina() < 100 ) then
		
			ply:SetStamina( ply:Stamina() + 0.25 );
			ply:SetExhausted( true );
		
			if ( ply:Stamina() > 100 ) then
			
				ply:SetStamina( 100 );
				ply:SetExhausted( false );
			
			elseif ( ply:Stamina() == 100 ) then
			
				ply:SetExhausted( false );
			
			end
		
		end
	
		-- Player status effects
		if ( IsRoundState( ROUND_INROUND ) && !ply:IsSpectating() && !ply:Deactivated() && !ply:HasStatusEffect( STATUS_NONE ) && ( ply.statusEffectTime < CurTime() ) ) then
		
			ply:SetStatusEffect( STATUS_NONE );
		
		end
	
		-- Player reactivation
		if ( IsRoundState( ROUND_INROUND ) && !ply:IsSpectating() && ply:Deactivated() && ( ply.deactivatedTime < CurTime() ) ) then
		
			ply:SetDeactivated( false, true );
		
		end
	
	end

end


-- Player control
local blockedKeys = { IN_JUMP, IN_WALK };
function GM:StartCommand( ply, ucmd )

	-- Block keys
	for k, v in ipairs( blockedKeys ) do
	
		if ( ucmd:KeyDown( v ) ) then
		
			ucmd:RemoveKey( v );
		
		end
	
	end

	-- Stamina
	if ( !ply:IsSpectating() && ucmd:KeyDown( IN_SPEED ) && ply:Exhausted() ) then
	
		ucmd:RemoveKey( IN_SPEED );
	
	end

end


-- Gets valid spectating players
function GM:GetValidSpectatingPlayers()

	local tab = {};

	for _, ply in ipairs( player.GetAll() ) do
	
		if ( IsValid( ply ) && ply:Alive() && !ply:Deactivated() && !ply:IsSpectating() ) then
		
			table.insert( tab, ply );
		
		end
	
	end

	return tab;

end


-- Get the number of players in the valid teams
function GM:NumberOfPlayers()

	if ( GAMEMODE.TeamBased ) then return ( team.NumPlayers( TEAM_BLUE ) + team.NumPlayers( TEAM_RED ) + team.NumPlayers( TEAM_YELLOW ) ); end

	return player.GetCount();

end


-- Highest ranking team
function GM:HighestRankingTeam()

	local storedScores = {};

	for i = 1, 3 do
	
		table.insert( storedScores, team.GetScore( i ) );
	
	end

	storedScores = table.SortByKey( storedScores );

	return storedScores[ 1 ];

end


-- First highest ranking player
function GM:GetRankingPlayer( num )

	if ( !num ) then return; end

	local sortedPlayers = {};

	for _, ply in ipairs( player.GetAll() ) do
	
		if ( !ply:IsSpectating() ) then
		
			sortedPlayers[ ply:UserID() ] = ( ( ply:Frags() * 50 ) - ply:EntIndex() );
		
		end
	
	end

	sortedPlayers = table.SortByKey( sortedPlayers );

	return Player( sortedPlayers[ num ] || 0 );

end
