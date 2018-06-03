-- Lazer Zone by daunknownfox2010

AddCSLuaFile( "cl_earlyfunctions.lua" );
AddCSLuaFile( "cl_help.lua" );
AddCSLuaFile( "cl_music.lua" );
AddCSLuaFile( "cl_pickteam.lua" );
AddCSLuaFile( "cl_scoreboard.lua" );
AddCSLuaFile( "cl_singleplayer.lua" );
AddCSLuaFile( "cl_targetid.lua" );
AddCSLuaFile( "vgui/playerinfo.lua" );
AddCSLuaFile( "vgui/scoreinfo.lua" );
AddCSLuaFile( "vgui/spawninfo.lua" );
AddCSLuaFile( "vgui/staminainfo.lua" );
AddCSLuaFile( "vgui/timer.lua" );

include( "shared.lua" );
include( "player.lua" );


-- Console Variables
local lz_sv_gametype = CreateConVar( "lz_sv_gametype", 0, { FCVAR_ARCHIVE, FCVAR_NOTIFY }, "Sets the Lazer Zone game type." );


-- Called when the gamemode is initialized
function GM:Initialize()

	-- Network strings
	util.AddNetworkString( "LZNETRoundNumber" );
	util.AddNetworkString( "LZNETMaxRounds" );
	util.AddNetworkString( "LZNETGameType" );
	util.AddNetworkString( "LZNETRoundTime" );
	util.AddNetworkString( "LZNETRoundState" );
	util.AddNetworkString( "LZNETRoundMusic" );
	util.AddNetworkString( "LZNETSpectatorTarget" );
	util.AddNetworkString( "LZNETInformationText" );
	util.AddNetworkString( "LZNETPlaySound" );
	util.AddNetworkString( "LZNETClientInitialized" );

	-- Set the game type
	SetGameType( lz_sv_gametype:GetInt() );

	-- Set round variables
	SetMaxRounds( 2 );

	-- Run console commands
	game.ConsoleCommand( "sv_defaultdeployspeed 1\n" );

end


-- Called every frame
local LZCurrentTeamInLead = 0;
local LZFirstPlacePlayer = Player( 0 );
local LZSecondPlacePlayer = Player( 0 );
local LZThirdPlacePlayer = Player( 0 );
function GM:Think()

	-- Display team in the lead
	if ( GAMEMODE.TeamBased && IsRoundState( ROUND_INROUND ) && ( LZCurrentTeamInLead != self:HighestRankingTeam() ) ) then
	
		LZCurrentTeamInLead = self:HighestRankingTeam();
	
		net.Start( "LZNETInformationText" );
			net.WriteString( string.upper( team.GetName( LZCurrentTeamInLead ) ).." IS IN THE LEAD!" );
			net.WriteInt( 6, 4 );
		net.Broadcast();
	
	end

	-- Display players in the lead
	if ( IsRoundState( ROUND_INROUND ) ) then
	
		if ( LZFirstPlacePlayer != self:GetRankingPlayer( 1 ) ) then
		
			LZFirstPlacePlayer = self:GetRankingPlayer( 1 );
		
			if ( IsValid( LZFirstPlacePlayer ) ) then
			
				-- Emit a sound for the player
				LZFirstPlacePlayer:EmitSound( "LazerZone.PlayerRankingFirst" );
			
				-- Publicly display ranking
				net.Start( "LZNETInformationText" );
					net.WriteString( string.upper( LZFirstPlacePlayer:Nick() ).." IS IN FIRST PLACE!" );
					net.WriteInt( 6, 4 );
				net.Broadcast();
			
			end
		
		end
	
		if ( LZSecondPlacePlayer != self:GetRankingPlayer( 2 ) ) then
		
			LZSecondPlacePlayer = self:GetRankingPlayer( 2 );
		
			if ( IsValid( LZSecondPlacePlayer ) ) then
			
				-- Emit a sound for the player
				LZSecondPlacePlayer:EmitSound( "LazerZone.PlayerRankingSecond" );
			
				-- Publicly display ranking
				net.Start( "LZNETInformationText" );
					net.WriteString( string.upper( LZSecondPlacePlayer:Nick() ).." IS IN SECOND PLACE!" );
					net.WriteInt( 6, 4 );
				net.Broadcast();
			
			end
		
		end
	
		if ( LZThirdPlacePlayer != self:GetRankingPlayer( 3 ) ) then
		
			LZThirdPlacePlayer = self:GetRankingPlayer( 3 );
		
			if ( IsValid( LZThirdPlacePlayer ) ) then
			
				-- Emit a sound for the player
				LZThirdPlacePlayer:EmitSound( "LazerZone.PlayerRankingThird" );
			
				-- Publicly display ranking
				net.Start( "LZNETInformationText" );
					net.WriteString( string.upper( LZThirdPlacePlayer:Nick() ).." IS IN THIRD PLACE!" );
					net.WriteInt( 6, 4 );
				net.Broadcast();
			
			end
		
		end
	
	end

end


-- Carries out actions when the player dies
function GM:DoPlayerDeath( ply, attacker, info )

	if ( ply:IsBot() ) then timer.Simple( 1, function() if ( IsValid( ply ) ) then ply:Spawn(); end end ); end

	-- Deactivate
	ply:SetDeactivated( true, true );

end


-- Entity received damage
local mp_friendlyfire = GetConVar( "mp_friendlyfire" );
function GM:EntityTakeDamage( ent, info )

	local attacker = info:GetAttacker();
	local inflictor = info:GetInflictor();

	-- Valid hitgroups
	local hitGroups = {};
	hitGroups[ HITGROUP_CHEST ] = true;
	hitGroups[ HITGROUP_STOMACH ] = true;
	hitGroups[ HITGROUP_LEFTARM ] = true;
	hitGroups[ HITGROUP_RIGHTARM ] = true;

	-- Is a player
	if ( IsRoundState( ROUND_INROUND ) && ent:IsPlayer() && !ent:Deactivated() && !ent:HasStatusEffect( STATUS_INVINCIBLE ) && IsValid( attacker ) && attacker:IsPlayer() && !attacker:Deactivated() && ( hitGroups[ ent:LastHitGroup() ] || attacker:HasStatusEffect( STATUS_NUKE ) ) && ( !GAMEMODE.TeamBased || ( ent:Team() != attacker:Team() ) || mp_friendlyfire:GetBool() ) ) then
	
		-- Score
		if ( GAMEMODE.TeamBased && ( ent:Team() == attacker:Team() ) ) then
		
			attacker:AddScore( -5 );
			if ( GAMEMODE.TeamBased ) then team.AddScore( attacker:Team(), -5 ); end
		
		else
		
			attacker:AddScore( 10 );
			if ( GAMEMODE.TeamBased ) then team.AddScore( attacker:Team(), 10 ); end
		
		end
	
		-- Deactivate
		ent:SetDeactivated( true, true );
	
		-- BS status effect because why not
		if ( attacker:HasStatusEffect( STATUS_NUKE ) ) then
		
			self:NukeTeam( attacker, ent:Team() );
		
		end
	
		-- Kill streak
		if ( !GAMEMODE.TeamBased || ( ent:Team() != attacker:Team() ) ) then attacker.killStreak = attacker.killStreak + 1; end
	
		-- Attacker kill streak handling
		if ( attacker:HasStatusEffect( STATUS_NONE ) && ( attacker.killStreak >= attacker.killStreakReq ) ) then
		
			attacker.killStreak = 0;
			if ( attacker.killStreakReq < 15 ) then
			
				attacker.killStreakReq = attacker.killStreakReq + 5;
			
			end
		
			attacker:SetStatusEffect( math.random( 1, 4 ) );
		
		end
	
		-- Death notice
		net.Start( "PlayerKilledByPlayer" );
			net.WriteEntity( ent );
			net.WriteString( inflictor:GetClass() );
			net.WriteEntity( attacker );
		net.Broadcast();
	
		MsgAll( attacker:Nick().." tagged "..ent:Nick().."\n" );
	
		if ( !GAMEMODE.TeamBased || ( ent:Team() != attacker:Team() ) ) then
		
			-- Play a bell sound for the attacker
			net.Start( "LZNETPlaySound" );
				net.WriteString( "buttons/bell1.wav" );
			net.Send( attacker );
		
		else
		
			-- Display information text
			net.Start( "LZNETInformationText" );
				net.WriteString( "FRIENDLY FIRE!" );
				net.WriteInt( 2, 4 );
			net.Broadcast();
		
		end
	
		return true;
	
	end

end


-- Player presses Show Help
function GM:ShowHelp( ply )

	ply:SendLua( "GAMEMODE:ShowHelp()" );

end


-- Gamemode is waiting for players
local function WaitingForPlayers()

	if ( GAMEMODE:NumberOfPlayers() >= 2 ) then
	
		timer.Destroy( "LZWaitingForPlayers" );
	
		SetRoundTime( 5 );
	
		timer.Simple( 5, function() GAMEMODE:StartPreRound(); end );
	
	end

end
timer.Create( "LZWaitingForPlayers", 1, 0, WaitingForPlayers );


-- Player PreActivation
local function PlayerPreActivate()

	-- Activate players
	for _, ply in ipairs( player.GetAll() ) do
	
		ply:SetDeactivated( false, true );
	
	end

end


-- Start gamemode preround
function GM:StartPreRound()

	-- Set round variables
	SetRoundNumber( GetRoundNumber() + 1 );
	SetRoundTime( 10 );
	SetRoundState( ROUND_PREROUND );

	-- Time scale
	game.SetTimeScale( 1.0 );

	-- Clean the map
	game.CleanUpMap();

	-- Respawn all the players
	for _, ply in ipairs( player.GetAll() ) do
	
		if ( !ply:IsSpectating() ) then
		
			ply:Spawn();
		
		end
	
	end

	-- Hide scoreboard
	BroadcastLua( "GAMEMODE:ScoreboardHide();" );

	-- Start the round
	timer.Simple( 8, PlayerPreActivate );

	-- Start the round
	timer.Simple( 10, function() GAMEMODE:StartRound(); end );

	-- Displays round information to all players
	BroadcastLua( "vgui.Create( \"SpawnInfo\" );" );

	-- Plays a siren
	net.Start( "LZNETPlaySound" );
		net.WriteString( "lazerzone/lz_buildup.mp3" );
	net.Broadcast();

end


-- Start gamemode round
function GM:StartRound()

	-- Horrible way to prevent the round from starting when there is not enough players
	if ( GAMEMODE:NumberOfPlayers() < 2 ) then
	
		timer.Simple( 1, function() GAMEMODE:StartRound(); end );
		return;
	
	end

	-- Set round variables
	SetRoundTime( 450 );
	SetRoundState( ROUND_INROUND );

	-- Unfreeze players
	for _, ply in ipairs( player.GetAll() ) do
	
		if ( !ply:IsSpectating() ) then
		
			ply:Freeze( false );
			ply.deactivatedTime = 0;
		
		end
	
	end

	-- Music
	net.Start( "LZNETRoundMusic" );
		net.WriteBool( true );
	net.Broadcast();

	-- Display information text
	net.Start( "LZNETInformationText" );
		net.WriteString( "GO!" );
		net.WriteInt( 4, 4 );
	net.Broadcast();

end


-- End gamemode round
function GM:EndRound()

	-- Set round variables
	SetRoundState( ROUND_ROUNDEND );

	-- Time scale
	game.SetTimeScale( 0.25 );

	-- Freeze players
	for _, ply in ipairs( player.GetAll() ) do
	
		if ( !ply:IsSpectating() ) then
		
			ply:SetStatusEffect( STATUS_NONE );
			ply:Freeze( true );
		
		end
	
	end

	-- Music
	net.Start( "LZNETRoundMusic" );
		net.WriteBool( false );
	net.Broadcast();

	-- Print winning team
	BroadcastLua( "GAMEMODE:PrintWinningStatistics();" );

	-- Display scoreboard
	timer.Simple( 0.25, function() BroadcastLua( "GAMEMODE:ScoreboardShow();" ); end );

	-- Continue
	if ( GetRoundNumber() < GetMaxRounds() ) then
	
		timer.Simple( 2.5, function() GAMEMODE:StartPreRound(); end );
	
	else
	
		timer.Simple( 3.75, function() GAMEMODE:LoadNextMap(); end );
	
	end

end


-- Loads next map
function GM:LoadNextMap()

	-- Time scale
	game.SetTimeScale( 1.0 );

	-- Loads the mapvote addon instead
	if ( MapVote ) then
	
		MapVote.Start( nil, nil, nil, nil );
		return;
	
	end

	game.LoadNextMap();

end


-- Nukes team (BS)
function GM:NukeTeam( attacker, id )

	for _, ply in ipairs( team.GetPlayers( id ) ) do
	
		if ( ply:Alive() && !ply:IsSpectating() && !ply:Deactivated() && ( ply != attacker ) ) then
		
			local damageInfo = DamageInfo();
			damageInfo:SetAttacker( attacker );
			if ( attacker:HoldingLazer() ) then damageInfo:SetInflictor( attacker:GetActiveWeapon() ); end
			damageInfo:SetDamage( 0 );
		
			ply:TakeDamageInfo( damageInfo );
		
		end
	
	end

	attacker.statusEffectTime = 0;

end


-- Processes the spectator target
function LZNETSpectatorTarget( len, ply )

	if ( !IsValid( ply ) ) then return; end
	if ( !ply:IsSpectating() ) then return; end
	if ( #GAMEMODE:GetValidSpectatingPlayers() <= 0 ) then return; end

	local shouldGoToNext = net.ReadBool();

	if ( shouldGoToNext ) then
	
		local foundTarget = table.FindNext( GAMEMODE:GetValidSpectatingPlayers(), ply:GetObserverTarget() );
		if ( IsValid( foundTarget ) ) then
		
			ply:SpectateEntity( foundTarget );
		
		end
	
	else
	
		local foundTarget = table.FindPrev( GAMEMODE:GetValidSpectatingPlayers(), ply:GetObserverTarget() );
		if ( IsValid( foundTarget ) ) then
		
			ply:SpectateEntity( foundTarget );
		
		end
	
	end

end
net.Receive( "LZNETSpectatorTarget", LZNETSpectatorTarget );


-- Client initialized
function LZNETClientInitialized( len, ply )

	FullNetworkUpdate( ply );

end
net.Receive( "LZNETClientInitialized", LZNETClientInitialized );
