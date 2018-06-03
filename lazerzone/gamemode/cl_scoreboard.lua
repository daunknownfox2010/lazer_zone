-- Lazer Zone by daunknownfox2010

surface.CreateFont( "ScoreboardDefault", {
	font	= "Helvetica",
	size	= 22,
	weight	= 800
} );

surface.CreateFont( "ScoreboardDefaultTitle", {
	font	= "Helvetica",
	size	= 32,
	weight	= 800
} );


-- Creates a vgui element for the player lines
local PLAYER_LINE = {

	Init = function( self )
	
		self.AvatarButton = self:Add( "DButton" );
		self.AvatarButton:Dock( LEFT );
		self.AvatarButton:SetSize( 32, 32 );
		self.AvatarButton.DoClick = function() self.Player:ShowProfile(); end
	
		self.Avatar = vgui.Create( "AvatarImage", self.AvatarButton );
		self.Avatar:SetSize( 32, 32 );
		self.Avatar:SetMouseInputEnabled( false );
	
		self.Name = self:Add( "DLabel" );
		self.Name:Dock( FILL );
		self.Name:SetFont( "ScoreboardDefault" );
		self.Name:SetTextColor( Color( 255, 255, 255 ) );
		self.Name:DockMargin( 8, 0, 0, 0 );
	
		self.Mute = self:Add( "DImageButton" );
		self.Mute:SetSize( 32, 32 );
		self.Mute:Dock( RIGHT );
	
		self.Ping = self:Add( "DLabel" );
		self.Ping:Dock( RIGHT );
		self.Ping:SetWidth( 75 );
		self.Ping:SetFont( "ScoreboardDefault" );
		self.Ping:SetTextColor( Color( 255, 255, 255 ) );
		self.Ping:SetContentAlignment( 5 );
	
		self.Kills = self:Add( "DLabel" );
		self.Kills:Dock( RIGHT );
		self.Kills:SetWidth( 150 );
		self.Kills:SetFont( "ScoreboardDefault" );
		self.Kills:SetTextColor( Color( 255, 255, 255 ) );
		self.Kills:SetContentAlignment( 5 );
	
		self:Dock( TOP );
		self:DockPadding( 3, 3, 3, 3 );
		self:SetHeight( 32 + 3 * 2 );
		self:DockMargin( 2, 0, 2, 2 );
	
	end,

	Setup = function( self, ply )
	
		self.Player = ply;
	
		self.Avatar:SetPlayer( ply );
	
		self:Think( self );
	
	end,

	Think = function( self )
	
		if ( !IsValid( self.Player ) ) then
		
			self:SetZPos( 9999 ); -- Causes a rebuild
			self:Remove();
			return;
		
		end
	
		if ( ( self.PName == nil ) || ( self.PName != self.Player:Nick() ) ) then
		
			self.PName = self.Player:Nick();
			self.Name:SetText( self.PName );
		
		end
	
		if ( ( self.NumKills == nil ) || ( self.NumKills != self.Player:Frags() ) ) then
		
			self.NumKills = self.Player:Frags();
			self.Kills:SetText( self.NumKills );
		
		end
	
		if ( ( self.NumPing == nil ) || ( self.NumPing != self.Player:Ping() ) ) then
		
			if ( self.Player:GetNWBool( "LZListenServerHost" ) ) then
			
				self.NumPing = "HOST";
			
			elseif ( self.Player:IsBot() ) then
			
				self.NumPing = "BOT";
			
			else
			
				self.NumPing = self.Player:Ping();
			
			end
			self.Ping:SetText( self.NumPing );
		
		end
	
		if ( ( self.Muted == nil ) || ( self.Muted != self.Player:IsMuted() ) ) then
		
			self.Muted = self.Player:IsMuted();
			if ( self.Muted ) then
			
				self.Mute:SetImage( "icon32/muted.png" );
			
			else
			
				self.Mute:SetImage( "icon32/unmuted.png" );
			
			end
		
			self.Mute.DoClick = function() self.Player:SetMuted( !self.Muted ); end
		
		end
	
		-- Connecting players go at the very bottom
		if ( self.Player:Team() == TEAM_CONNECTING ) then
		
			self:SetZPos( 2000 + self.Player:EntIndex() );
			return;
		
		end
	
		-- This is what sorts the list
		self:SetZPos( ( self.NumKills * -50 ) + self.Player:EntIndex() );
	
	end,

	Paint = function( self, w, h )
	
		if ( !IsValid( self.Player ) ) then
		
			return;
		
		end
	
		-- We draw our background a different colour based on the status of the player
		draw.RoundedBox( 4, 0, 0, w, h, Color( 127.5, 127.5, 127.5, 200 ) );
		draw.RoundedBox( 4, 0, 0, 38, h, self.Player:GetPlayerColorStructure() );
	
	end

};

PLAYER_LINE = vgui.RegisterTable( PLAYER_LINE, "DPanel" );


-- Creates a vgui element for the scoreboard panel
local SCORE_BOARD = {

	Init = function( self )
	
		self.Header = self:Add( "Panel" );
		self.Header:Dock( TOP );
		self.Header:SetHeight( 100 );
	
		self.Name = self.Header:Add( "DLabel" );
		self.Name:SetFont( "ScoreboardDefaultTitle" );
		self.Name:SetTextColor( Color( 255, 255, 255, 255 ) );
		self.Name:Dock( TOP );
		self.Name:SetHeight( 40 );
		self.Name:SetContentAlignment( 5 );
		self.Name:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) );
	
		self.NumPlayers = self.Header:Add( "DLabel" );
		self.NumPlayers:SetFont( "ScoreboardDefault" );
		self.NumPlayers:SetTextColor( Color( 255, 255, 255, 255 ) );
		self.NumPlayers:SetPos( 5, 100 - 30 );
		self.NumPlayers:SetSize( 300, 30 );
		self.NumPlayers:SetContentAlignment( 4 );
		self.NumPlayers:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) );
	
		self.Rounds = self.Header:Add( "DLabel" );
		self.Rounds:SetFont( "ScoreboardDefault" );
		self.Rounds:SetTextColor( Color( 255, 255, 255, 255 ) );
		self.Rounds:Dock( TOP );
		self.Rounds:SetHeight( 40 );
		self.Rounds:SetContentAlignment( 5 );
		self.Rounds:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) );
	
		self.Scores = self:Add( "DScrollPanel" );
		self.Scores:Dock( FILL );
	
	end,

	PerformLayout = function( self )
	
		self:SetSize( 700, ScrH() - 200 );
		self:SetPos( ScrW() / 2 - 350, 100 );
	
	end,

	Paint = function( self, w, h )
	
		draw.RoundedBox( 8, 0, 0, w, h, Color( 0, 0, 0, 200 ) );
	
	end,

	Think = function( self, w, h )
	
		self.Name:SetText( GetHostName() );
	
		self.NumPlayers:SetText( "Players: "..player.GetCount() );
	
		self.Rounds:SetText( "Round: "..GetRoundNumber().."/"..GetMaxRounds() );
	
		-- Loop through each player, and if one doesn't have a score entry - create it.
		local plyrs = player.GetAll();
		for id, ply in pairs( plyrs ) do
		
			if ( IsValid( ply.ScoreEntry ) ) then continue; end
		
			ply.ScoreEntry = vgui.CreateFromTable( PLAYER_LINE, ply.ScoreEntry );
			ply.ScoreEntry:Setup( ply );
		
			self.Scores:AddItem( ply.ScoreEntry );
		
		end
	
	end

};

SCORE_BOARD = vgui.RegisterTable( SCORE_BOARD, "EditablePanel" );


-- Sets the scoreboard to visible
function GM:ScoreboardShow()

	if ( game.SinglePlayer() ) then return; end

	if ( !IsValid( g_Scoreboard ) ) then
	
		g_Scoreboard = vgui.CreateFromTable( SCORE_BOARD );
	
	end

	if ( IsValid( g_Scoreboard ) ) then
	
		g_Scoreboard:Show();
		g_Scoreboard:MakePopup();
		g_Scoreboard:SetKeyboardInputEnabled( false );
	
	end

end


-- Hides the scoreboard
function GM:ScoreboardHide()

	if ( IsValid( g_Scoreboard ) ) then
	
		g_Scoreboard:Hide();
	
	end

end


-- If you prefer to draw your scoreboard the stupid way (without vgui)
function GM:HUDDrawScoreBoard()
end
