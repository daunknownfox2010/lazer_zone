-- Lazer Zone by daunknownfox2010

AddCSLuaFile();


-- Local variables
local LZGameType = 0;
local LZRoundNumber = 0;
local LZMaxRounds = 0;
local LZRoundTime = 0;
local LZRoundState = 0;


-- Set the game type
GAMETYPE_TEAM = 0;
GAMETYPE_DM = 1;
function SetGameType( num )

	if ( CLIENT ) then return; end

	if ( num <= 0 ) then
	
		GAMEMODE.TeamBased = true;
	
	elseif ( num >= 1 ) then
	
		GAMEMODE.TeamBased = false;
	
	end

	LZGameType = num;

	net.Start( "LZNETGameType" );
		net.WriteInt( num, 4 );
	net.Broadcast();

end


-- Get the game type
function GetGameType()

	return LZGameType;

end


-- Is the current game type
function IsGameType( num )

	return ( num == LZGameType );

end


-- Network the game type
if ( CLIENT ) then

	function LZNETGameType( len )
	
		LZGameType = net.ReadInt( 4 );
	
		if ( LZGameType <= 0 ) then
		
			GAMEMODE.TeamBased = true;
		
		elseif ( LZGameType >= 1 ) then
		
			GAMEMODE.TeamBased = false;
		
		end
	
		hook.Call( "InitializeVGUI", GAMEMODE );
	
	end
	net.Receive( "LZNETGameType", LZNETGameType );

end


-- Set round number
function SetRoundNumber( num )

	if ( CLIENT ) then return; end

	LZRoundNumber = num;

	net.Start( "LZNETRoundNumber" );
		net.WriteInt( num, 8 );
	net.Broadcast();

end


-- Network round number
if ( CLIENT ) then

	function LZNETRoundNumber( len )
	
		LZRoundNumber = net.ReadInt( 8 );
	
	end
	net.Receive( "LZNETRoundNumber", LZNETRoundNumber );

end


-- Get round number
function GetRoundNumber()

	return LZRoundNumber;

end


-- Set max rounds
function SetMaxRounds( num )

	if ( CLIENT ) then return; end

	LZMaxRounds = num;

	net.Start( "LZNETMaxRounds" );
		net.WriteInt( num, 8 );
	net.Broadcast();

end


-- Network max rounds
if ( CLIENT ) then

	function LZNETMaxRounds( len )
	
		LZMaxRounds = net.ReadInt( 8 );
	
	end
	net.Receive( "LZNETMaxRounds", LZNETMaxRounds );

end


-- Get max rounds
function GetMaxRounds()

	return LZMaxRounds;

end


-- Set round time
function SetRoundTime( num )

	if ( CLIENT ) then return; end

	LZRoundTime = CurTime() + num;

	net.Start( "LZNETRoundTime" );
		net.WriteDouble( num );
	net.Broadcast();

	if ( timer.Exists( "LZRoundTimer" ) ) then
	
		timer.Destroy( "LZRoundTimer" );
	
	end

	timer.Create( "LZRoundTimer", num, 1, function() if ( IsRoundState( ROUND_INROUND ) ) then GAMEMODE:EndRound(); end end );

end


-- Network round time
if ( CLIENT ) then

	function LZNETRoundTime( len )
	
		LZRoundTime = CurTime() + net.ReadDouble();
	
	end
	net.Receive( "LZNETRoundTime", LZNETRoundTime );

end


-- Get round time
function GetRoundTime()

	return LZRoundTime;

end


-- Set round state
ROUND_WFP = 0;
ROUND_PREROUND = 1;
ROUND_INROUND = 2;
ROUND_ROUNDEND = 3;
function SetRoundState( num )

	if ( CLIENT ) then return; end

	LZRoundState = num;

	net.Start( "LZNETRoundState" );
		net.WriteInt( num, 4 );
	net.Broadcast();

end


-- Network round state
if ( CLIENT ) then

	function LZNETRoundState( len )
	
		LZRoundState = net.ReadInt( 4 );
	
	end
	net.Receive( "LZNETRoundState", LZNETRoundState );

end


-- Get round state
function GetRoundState()

	return LZRoundState;

end


-- Is in round state
function IsRoundState( state )

	return ( LZRoundState == state );

end


-- Full network update
function FullNetworkUpdate( ply )

	if ( CLIENT ) then return; end
	if ( !IsValid( ply ) ) then return; end
	if ( !ply:IsPlayer() ) then return; end
	if ( ply:IsBot() ) then return; end

	net.Start( "LZNETGameType" );
		net.WriteInt( LZGameType, 4 );
	net.Broadcast();

	net.Start( "LZNETRoundNumber" );
		net.WriteInt( LZRoundNumber, 8 );
	net.Send( ply );

	net.Start( "LZNETMaxRounds" );
		net.WriteInt( LZMaxRounds, 8 );
	net.Send( ply );

	if ( timer.Exists( "LZRoundTimer" ) ) then
	
		net.Start( "LZNETRoundTime" );
			net.WriteDouble( timer.TimeLeft( "LZRoundTimer" ) );
		net.Send( ply );
	
	end

	net.Start( "LZNETRoundState" );
		net.WriteInt( LZRoundState, 4 );
	net.Send( ply );

	net.Start( "LZNETRoundMusic" );
		net.WriteBool( IsRoundState( ROUND_INROUND ) );
	net.Send( ply );

end
