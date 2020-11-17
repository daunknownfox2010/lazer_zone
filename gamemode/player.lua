-- Lazer Zone by daunknownfox2010


-- Console Variables
local lz_sv_custom_playermodels = CreateConVar( "lz_sv_custom_playermodels", 0, { FCVAR_ARCHIVE, FCVAR_NOTIFY }, "Allows use of custom playermodels in the gamemode." );


-- Called when a player wants to pick up a weapon
function GM:PlayerCanPickupWeapon( ply, wep )

	return ( wep:GetClass() == "weapon_lazergun" );

end


-- Called when a player wants to pick up an item
function GM:PlayerCanPickupItem( ply, item )

	return false;

end


-- Player has disconnected from the server
function GM:PlayerDisconnected( ply )

	local playerFrags = ply:Frags();
	local playerTeam = ply:Team();

	team.AddScore( playerTeam, -playerFrags );

end


-- Called when the player is dead
function GM:PlayerDeathThink( ply )

	ply:Spawn();

end


-- Called just before the player's first spawn
function GM:PlayerInitialSpawn( ply )

	player_manager.SetPlayerClass( ply, "player_lazer" );

	ply:SetTeam( TEAM_UNASSIGNED );

	ply.timesShot = 0;

	if ( GAMEMODE.TeamBased ) then
	
		ply:ConCommand( "gm_showteam" );
	
	end

	if ( GAMEMODE.TeamBased && ( ply:IsBot() ) ) then
	
		timer.Simple( 0.5, function() if ( IsValid( ply ) ) then GAMEMODE:PlayerRequestTeam( ply, team.BestAutoJoinTeam() ); end end );
	
	end

	ply:ChatPrint( "Welcome to Lazer Zone! Current version: "..GAMEMODE.Version );

	if ( !game.IsDedicated() ) then ply:SetNWBool( "LZListenServerHost", ply:IsListenServerHost() ); end

end


-- Player spawns as spectator
function GM:PlayerSpawnAsSpectator( ply )

	ply:StripWeapons();
	ply:Freeze( false );

	-- Locks the player in singleplayer
	if ( game.SinglePlayer() ) then ply:Lock(); end

	if ( ply:Team() == TEAM_UNASSIGNED ) then

		ply:Spectate( OBS_MODE_FIXED );
		return;

	end

	ply:SetTeam( TEAM_SPECTATOR );
	ply:Spectate( OBS_MODE_CHASE );

end


-- Called when a player spawns
function GM:PlayerSpawn( ply )

	-- Player is spectating
	if ( GAMEMODE.TeamBased && ply:IsSpectating() ) then
	
		self:PlayerSpawnAsSpectator( ply );
		ply:SetPlayerColor( Vector( 0.125, 0.125, 0.125 ) );
		return;
	
	end

	-- Not spectating
	ply:UnSpectate();

	ply:SetupHands();

	player_manager.OnPlayerSpawn( ply );
	player_manager.RunClass( ply, "Spawn" );

	-- Set the player's collisions
	ply:SetCustomCollisionCheck( true );

	-- Blood color
	ply:SetBloodColor( DONT_BLEED );

	-- Deactivation
	ply:SetDeactivated( true );

	-- Status effect
	ply:SetStatusEffect( STATUS_NONE );
	ply.statusEffectTime = 0;

	-- Kill streaks
	ply.killStreak = 0;
	ply.killStreakReq = 5;

	-- Freeze players in preround or end of the round
	if ( IsRoundState( ROUND_PREROUND ) || IsRoundState( ROUND_ROUNDEND ) ) then ply:Freeze( true ); end

	-- Call item loadout function
	hook.Call( "PlayerLoadout", GAMEMODE, ply );

	-- Set player model
	hook.Call( "PlayerSetModel", GAMEMODE, ply );

end


-- Set the player's model
function GM:PlayerSetModel( ply )

	-- Get the model information
	local cl_playermodel = ply:GetInfo( "cl_playermodel" );
	local modelname = player_manager.TranslatePlayerModel( cl_playermodel );

	-- Prevent other player models
	if ( !lz_sv_custom_playermodels:GetBool() && !table.HasValue( GAMEMODE.PlayerModels, modelname ) ) then
	
		modelname = table.Random( GAMEMODE.PlayerModels );
	
	end

	-- Set the player model
	util.PrecacheModel( modelname );
	ply:SetModel( modelname );

	-- Set the player model skin
	local skin = ply:GetInfoNum( "cl_playerskin", 0 );
	ply:SetSkin( skin );

	-- Set the player model bodygroups
	local groups = ply:GetInfo( "cl_playerbodygroups" );

	if ( groups == nil ) then
	
		groups = "";
	
	end

	local groups = string.Explode( " ", groups );

	for k = 0, ply:GetNumBodyGroups() - 1 do
	
		ply:SetBodygroup( k, tonumber( groups[ k + 1 ] ) || 0 );
	
	end

	-- Set the player color
	if ( GAMEMODE.TeamBased ) then
	
		ply:SetPlayerColor( Vector( team.GetColor( ply:Team() ).r / 255, team.GetColor( ply:Team() ).g / 255, team.GetColor( ply:Team() ).b / 255 ) );
	
	else
	
		local col = Vector( math.random( 32, 255 ) / 255, math.random( 32, 255 ) / 255, math.random( 32, 255 ) / 255 );
		ply:SetPlayerColor( Vector( col ) );
	
	end

end


-- Give the player the default spawning weapons/ammo
function GM:PlayerLoadout( ply )

	-- Remove all previous items
	ply:RemoveAllItems();

	-- Give lazer gun
	if ( IsRoundState( ROUND_PREROUND ) || IsRoundState( ROUND_INROUND ) ) then ply:Give( "weapon_lazergun" ); end

	-- Make the lazer gun invisible too if the player is deactivated
	if ( ply:Deactivated() && IsValid( ply:GetActiveWeapon() ) ) then ply:GetActiveWeapon():SetNoDraw( true ); end

end


-- Find out if the spawnpoint is suitable or not
function GM:IsSpawnpointSuitable( ply, ent, suitable )

	return true;

end


-- Plays default death sound
function GM:PlayerDeathSound()

	return true;

end


-- Player typed kill in console
function GM:CanPlayerSuicide( ply )

	return false;

end


-- Player switches flashlight
function GM:PlayerSwitchFlashlight( ply, on )

	return false;

end


-- Player changes team
function GM:OnPlayerChangedTeam( ply, oldteam, newteam )

	if ( newteam == TEAM_SPECTATOR ) then
	
		team.AddScore( oldteam, -ply:Frags() );
	
		local Pos = ply:EyePos();
		ply:SetScore( 0 );
		ply:Spawn();
		ply:SetPos( Pos );
		ply:SetDeactivated( false );
	
	elseif ( oldteam == TEAM_SPECTATOR ) then
	
		ply:Spawn();
	
	else
	
		team.AddScore( oldteam, -ply:Frags() );
		team.AddScore( newteam, ply:Frags() );
	
	end

	PrintMessage( HUD_PRINTTALK, Format( "%s joined '%s'", ply:Nick(), team.GetName( newteam ) ) );

end


-- Return amount of damage to do due to fall
function GM:GetFallDamage( ply, speed )

	return 0;

end


-- Player is allowed to taunt
function GM:PlayerShouldTaunt( ply, act )

	return false;

end
