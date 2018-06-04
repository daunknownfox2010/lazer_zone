-- Lazer Zone by daunknownfox2010

if ( system.IsLinux() ) then

	surface.CreateFont( "HelpMenu", {
		font	= "DejaVu Sans",
		size	= ControlledScreenScale( 14 ),
		weight	= 500
	} );

else

	surface.CreateFont( "HelpMenu", {
		font	= "Tahoma",
		size	= ControlledScreenScale( 13 ),
		weight	= 500
	} );

end


-- When the player uses the Show Help bind
function GM:ShowHelp()

	if ( IsValid( self.HelpMenuFrame ) ) then return; end
	if ( game.SinglePlayer() ) then return; end

	self.HelpMenuFrame = vgui.Create( "DFrame" );
	function self.HelpMenuFrame:Paint( w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) ); end
	self.HelpMenuFrame:SetTitle( "Help" );

	local HelpLabel = self.HelpMenuFrame:Add( "DLabel" );
	HelpLabel:SetFont( "HelpMenu");
	HelpLabel:SetText( "Lazer Zone" );
	HelpLabel:Dock( TOP );
	HelpLabel:DockMargin( 0, ControlledScreenScale( 2.5 ), 0, 0 );
	HelpLabel:SetContentAlignment( 5 );
	HelpLabel:SizeToContents();
	self.HelpMenuFrame:SetTitle( "Help" );

	local HelpLabel = self.HelpMenuFrame:Add( "DLabel" );
	HelpLabel:SetFont( "HelpMenu");
	HelpLabel:SetText( "Lazer Zone is a simple gamemode created by "..GAMEMODE.Author..".\n\nCurrently, there is only two game types available: Team & Deathmatch.\n\nIn Team, there are three teams: Blue, Red & Yellow.\n> The team with the most points is the winner.\n> Team \"Bases\" are enabled and can be destroyed for lots of points.\n> Getting tagged will instantly deactivate you.\n> Various special abilities are available." );
	HelpLabel:SetTextColor( Color( 255, 255, 255 ) );
	HelpLabel:Dock( FILL );
	HelpLabel:SetContentAlignment( 7 );
	HelpLabel:DockMargin( 0, ControlledScreenScale( 5 ), 0, 0 );
	HelpLabel:SizeToContents();

	self.HelpMenuFrame:SetDraggable( false );
	self.HelpMenuFrame:SetSize( ControlledScreenScale( 350 ), ControlledScreenScale( 200 ) );
	self.HelpMenuFrame:Center();
	self.HelpMenuFrame:MakePopup();
	self.HelpMenuFrame:SetKeyboardInputEnabled( false );

end


-- Called to hide the help menu
function GM:HideHelp()

	if ( IsValid( self.HelpMenuFrame ) ) then
	
		self.HelpMenuFrame:Remove();
		self.HelpMenuFrame = nil;
	
	end

end
