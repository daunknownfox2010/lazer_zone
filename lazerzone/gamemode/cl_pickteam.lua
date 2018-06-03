-- Lazer Zone by daunknownfox2010

if ( system.IsLinux() ) then

	surface.CreateFont( "TeamSelection", {
		font	= "DejaVu Sans",
		size	= ControlledScreenScale( 14 ),
		weight	= 500
	} );

else

	surface.CreateFont( "TeamSelection", {
		font	= "Tahoma",
		size	= ControlledScreenScale( 13 ),
		weight	= 500
	} );

end


-- When the player uses the Show Team bind
function GM:ShowTeam()

	if ( IsValid( self.TeamSelectFrame ) ) then return; end
	if ( game.SinglePlayer() ) then return; end

	self.TeamSelectFrame = vgui.Create( "DFrame" );
	function self.TeamSelectFrame:Paint( w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) ); end
	self.TeamSelectFrame:SetTitle( "Pick Team" );
	
	local AllTeams = team.GetAllTeams();
	local y = ControlledScreenScale( 30 );

	local Team = vgui.Create( "DButton", self.TeamSelectFrame );
	function Team.DoClick() self:HideTeam(); RunConsoleCommand( "changeteam", team.BestAutoJoinTeam() ); end
	function Team:Paint( w, h ) draw.RoundedBox( 2, 0, 0, w, h, Color( 150, 150, 150, 255 ) ); end
	Team:SetPos( ControlledScreenScale( 10 ), y );
	Team:SetSize( ControlledScreenScale( 140 ), ControlledScreenScale( 20 ) );
	Team:SetFont( "TeamSelection" );
	Team:SetText( "Auto" );
	Team:SetTextColor( Color( 255, 255, 255 ) );

	y = y + ControlledScreenScale( 30 );

	for ID, TeamInfo in pairs( AllTeams ) do
	
		if ( ID == TEAM_SPECTATOR ) then
		
			local Team = vgui.Create( "DButton", self.TeamSelectFrame );
			function Team.DoClick() self:HideTeam(); RunConsoleCommand( "changeteam", ID ); end
			function Team:Paint( w, h ) draw.RoundedBox( 2, 0, 0, w, h, Color( 100, 100, 100, 255 ) ); end
			Team:SetPos( ControlledScreenScale( 10 ), y );
			Team:SetSize( ControlledScreenScale( 140 ), ControlledScreenScale( 20 ) );
			Team:SetFont( "TeamSelection" );
			Team:SetText( TeamInfo.Name );
			Team:SetTextColor( Color( 255, 255, 255 ) );
		
			if ( IsValid( LocalPlayer() ) && ( LocalPlayer():Team() == ID ) ) then
			
				Team:SetDisabled( true );
			
			end
		
			y = y + ControlledScreenScale( 30 );
		
		end
	
	end

	if ( ( LocalPlayer():Team() == TEAM_CONNECTING ) || ( GAMEMODE.TeamBased && ( LocalPlayer():Team() == TEAM_UNASSIGNED ) ) ) then self.TeamSelectFrame:ShowCloseButton( false ); end
	self.TeamSelectFrame:SetDraggable( false );
	self.TeamSelectFrame:SetSize( ControlledScreenScale( 160 ), y );
	self.TeamSelectFrame:Center();
	self.TeamSelectFrame:MakePopup();
	self.TeamSelectFrame:SetKeyboardInputEnabled( false );

end


-- Called to hide the team selection
function GM:HideTeam()

	if ( IsValid( self.TeamSelectFrame ) ) then
	
		self.TeamSelectFrame:Remove();
		self.TeamSelectFrame = nil;
	
	end

end
