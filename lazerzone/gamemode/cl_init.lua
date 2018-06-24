-- Lazer Zone by daunknownfox2010

include( "cl_earlyfunctions.lua" );
include( "cl_help.lua" );
include( "cl_music.lua" );
include( "cl_pickteam.lua" );
include( "cl_scoreboard.lua" );
include( "cl_singleplayer.lua" );
include( "cl_targetid.lua" );
include( "shared.lua" );
include( "vgui/playerinfo.lua" );
include( "vgui/scoreinfo.lua" );
include( "vgui/spawninfo.lua" );
include( "vgui/staminainfo.lua" );
include( "vgui/timer.lua" );


-- Console Variables
local lz_cl_player_dynamic_lights = CreateClientConVar( "lz_cl_player_dynamic_lights", 1, true, false, "Other players will emit a dynamic light." );


-- Called when the gamemode is initialized
function GM:Initialize()

	-- Killicon
	killicon.AddFont( "weapon_lazergun", "HL2MPTypeDeath", "-", Color( 255, 80, 0, 255 ) );

	-- Set the scoreboard to false
	GAMEMODE.ShowScoreboard = false;

end


-- Called after entities were initialized
function GM:InitPostEntity()

	-- Initialize the default music path
	self:AddMusicPath( "lazerzone/music/", "wav" );
	self:AddMusicPath( "lazerzone/music/", "mp3" );

	-- Radiosity
	RunConsoleCommand( "r_radiosity", "4" );

	-- Client initialized
	net.Start( "LZNETClientInitialized" );
	net.SendToServer();

end


-- Called every frame
function GM:PlayerBindPress( ply, bind, down )

	-- Spectator things
	if ( ply:Team() == TEAM_SPECTATOR ) then
	
		if ( ( string.lower( bind ) == "+attack" ) && down ) then
		
			net.Start( "LZNETSpectatorTarget" );
				net.WriteBool( true );
			net.SendToServer();
		
		elseif ( ( string.lower( bind ) == "+attack2" ) && down ) then
		
			net.Start( "LZNETSpectatorTarget" );
				net.WriteBool( false );
			net.SendToServer();
		
		end
	
	end

	return false;

end


-- Return true if we should should draw the named element
function GM:HUDShouldDraw( name )

	-- Prevent these elements from drawing
	local hud_elements = { [ "CHudHealth" ] = true, [ "CHudBattery" ] = true, [ "CHudAmmo" ] = true, [ "CHudWeaponSelection" ] = true };
	if ( hud_elements[ name ] ) then return false; end

	-- Allow the weapon to override this
	local ply = LocalPlayer();
	if ( IsValid( ply ) ) then
	
		local wep = ply:GetActiveWeapon();
	
		if ( IsValid( wep ) && wep.HUDShouldDraw != nil ) then
		
			return wep.HUDShouldDraw( wep, name );
		
		end
	
	end

	return true;

end


-- Paints the HUD
local LZInformationText = {};
function GM:HUDPaint()

	-- Waiting for players
	if ( IsRoundState( ROUND_WFP ) ) then
	
		draw.SimpleTextOutlined( "WAITING FOR PLAYERS", "DermaLarge", ScrW() / 2, ScrH() / 1.5, Color( 255, 255, 255, math.Clamp( math.sin( CurTime() ) * 255, 128, 255 ) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, math.Clamp( math.sin( CurTime() ) * 255, 128, 255 ) ) );
	
	end

	-- Information Text
	for k, v in ipairs( LZInformationText ) do
	
		-- Lerp stuff
		v.x = ( ScrW() / 2 ) + math.Clamp( math.Remap( v.time - CurTime(), v.timeSet - 0.5, v.timeSet, 0, ScrW() ), 0, ScrW() ) - math.Clamp( math.Remap( v.time - CurTime(), 0.5, 0, 0, ScrW() ), 0, ScrW() );
		v.y = ( ScrH() / 2 ) + 20 + ( 40 * k );
		if ( v.lerp ) then
		
			v.x = ( v.x * 0.15 ) + ( v.lerp.x * 0.85 );
			v.y = ( v.y * 0.3 ) + ( v.lerp.y * 0.7 );
		
		end
		v.lerp = v.lerp or {};
		v.lerp.x = v.x;
		v.lerp.y = v.y;
	
		-- Draw text
		draw.SimpleTextOutlined( v.text, "CloseCaption_Normal", v.x, v.y, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) );
	
		-- Delete when time is up
		if ( v.time < CurTime() ) then
		
			table.remove( LZInformationText, k );
		
		end
	
	end

	-- You are dead
	if ( IsRoundState( ROUND_INROUND ) && LocalPlayer():Deactivated() ) then
	
		draw.SimpleTextOutlined( "YOU ARE DEAD", "Trebuchet18", ScrW() / 2, ScrH() / 2.5, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0, 255 ) );
		draw.SimpleTextOutlined( "YOU WILL RESPAWN IN 6-8 SECONDS", "Trebuchet18", ScrW() / 2, ScrH() / 2.5 + 20, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0, 255 ) );
	
	end

	-- Target ID
	hook.Run( "HUDDrawTargetID" );

	-- Death notices
	hook.Run( "DrawDeathNotice", 0.85, 0.04 );

end


-- Draws effects
function GM:RenderScreenspaceEffects()

	-- Preround coloring
	if ( IsRoundState( ROUND_PREROUND ) ) then
	
		if ( GetRoundTime() >= CurTime() ) then
		
			local colourValue = math.Clamp( ( 6 - ( GetRoundTime() - CurTime() ) ) / 6, 0, 1 );
			DrawColorModify( { [ "$pp_colour_contrast" ] = 1, [ "$pp_colour_colour" ] = colourValue } );
		
		end
	
	end

end


-- Process player chat
function GM:OnPlayerChat( ply, text, team, dead )

	local tab = {};

	if ( dead || ( IsRoundState( ROUND_INROUND ) && ply:Deactivated() ) ) then
	
		table.insert( tab, Color( 255, 30, 40 ) );
		table.insert( tab, "*DEAD* " );
	
	end

	if ( team ) then
	
		table.insert( tab, Color( 30, 160, 40 ) );
		table.insert( tab, "(TEAM) " );
	
	end

	if ( IsValid( ply ) ) then
	
		table.insert( tab, ply:GetPlayerColorStructure() );
		table.insert( tab, ply:Nick() );
	
	else
	
		table.insert( tab, "Console" );
	
	end

	table.insert( tab, Color( 255, 255, 255 ) );
	table.insert( tab, ": " .. text );

	chat.AddText( unpack( tab ) );
	chat.PlaySound();

	return true;

end


-- After the player has been drawn
function GM:PostPlayerDraw( ply )

	-- Dynamic light
	if ( lz_cl_player_dynamic_lights:GetBool() && ply:Alive() && !ply:Deactivated() && !ply:IsSpectating() && !ply:HasStatusEffect( STATUS_INVISIBLE ) && ( ply != LocalPlayer() ) ) then
	
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


-- Initialize the VGUI elements
local VGUI_PLAYER_INFO = nil;
local VGUI_SCORE_INFO = nil;
local VGUI_STAMINA_INFO = nil;
local VGUI_TIMER = nil;
function GM:InitializeVGUI()

	-- Delete the already existing Player Info VGUI element
	if ( IsValid( VGUI_PLAYER_INFO ) ) then
	
		VGUI_PLAYER_INFO:Remove();
		VGUI_PLAYER_INFO = nil;
	
	end

	-- Delete the already existing Score Info VGUI element
	if ( IsValid( VGUI_SCORE_INFO ) ) then
	
		VGUI_SCORE_INFO:Remove();
		VGUI_SCORE_INFO = nil;
	
	end

	-- Delete the already existing Stamina Info VGUI element
	if ( IsValid( VGUI_STAMINA_INFO ) ) then
	
		VGUI_STAMINA_INFO:Remove();
		VGUI_STAMINA_INFO = nil;
	
	end

	-- Delete the already existing Timer VGUI element
	if ( IsValid( VGUI_TIMER ) ) then
	
		VGUI_TIMER:Remove();
		VGUI_TIMER = nil;
	
	end

	-- VGUI Elements
	if ( game.SinglePlayer() ) then
	
		self:InitSinglePlayer();
		gui.EnableScreenClicker( true );
	
	else
	
		VGUI_PLAYER_INFO = vgui.Create( "PlayerInfo" );
		VGUI_SCORE_INFO = vgui.Create( "ScoreInfo" );
		VGUI_STAMINA_INFO = vgui.Create( "StaminaInfo" );
		VGUI_TIMER = vgui.Create( "Timer" );
	
	end

end


-- Prints the winning statistics
function GM:PrintWinningStatistics()

	local tab = {};
	local winningTeam = self:HighestRankingTeam();
	local firstPlacePlayer = self:GetRankingPlayer( 1 );
	local secondPlacePlayer = self:GetRankingPlayer( 2 );
	local thirdPlacePlayer = self:GetRankingPlayer( 3 );

	if ( GAMEMODE.TeamBased ) then
	
		table.insert( tab, team.GetColor( winningTeam ) );
		table.insert( tab, team.GetName( winningTeam ) );
	
		table.insert( tab, Color( 255, 255, 255 ) );
		table.insert( tab, " is the winning team!" );
	
	end

	chat.AddText( unpack( tab ) );

	if ( IsValid( firstPlacePlayer ) ) then
	
		tab = {};
	
		table.insert( tab, firstPlacePlayer:GetPlayerColorStructure() );
		table.insert( tab, firstPlacePlayer:Nick() );
	
		table.insert( tab, Color( 255, 255, 255 ) );
		table.insert( tab, " ended in first place!" );
	
		chat.AddText( unpack( tab ) );
	
	end

	if ( IsValid( secondPlacePlayer ) ) then
	
		tab = {};
	
		table.insert( tab, secondPlacePlayer:GetPlayerColorStructure() );
		table.insert( tab, secondPlacePlayer:Nick() );
	
		table.insert( tab, Color( 255, 255, 255 ) );
		table.insert( tab, " ended in second place!" );
	
		chat.AddText( unpack( tab ) );
	
	end

	if ( IsValid( thirdPlacePlayer ) ) then
	
		tab = {};
	
		table.insert( tab, thirdPlacePlayer:GetPlayerColorStructure() );
		table.insert( tab, thirdPlacePlayer:Nick() );
	
		table.insert( tab, Color( 255, 255, 255 ) );
		table.insert( tab, " ended in third place!" );
	
		chat.AddText( unpack( tab ) );
	
	end

end


-- Get information text
function LZNETInformationText( len )

	local sentText = {};
	sentText.text = net.ReadString();
	sentText.time = CurTime() + net.ReadInt( 4 ) + 1;
	sentText.timeSet = sentText.time - CurTime();

	table.insert( LZInformationText, sentText );

end
net.Receive( "LZNETInformationText", LZNETInformationText );


-- Server makes the client play a sound
local LZPlaySoundCooldown = 0;
function LZNETPlaySound( len )

	if ( LZPlaySoundCooldown >= CurTime() ) then return; end

	surface.PlaySound( net.ReadString() );

	LZPlaySoundCooldown = CurTime() + 0.05;

end
net.Receive( "LZNETPlaySound", LZNETPlaySound );
