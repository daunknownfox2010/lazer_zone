-- Lazer Zone by daunknownfox2010

if ( !game.SinglePlayer() ) then return; end


-- Single player stuff
function GM:InitSinglePlayer()

	local Background = vgui.Create( "DPanel" );
	function Background:Paint( w, h ) surface.SetDrawColor( 32, 32, 32, 255 ); surface.DrawRect( 0, 0, w, h ); end
	Background:SetSize( ScrW(), ScrH() );

	local StartFrame = vgui.Create( "DFrame" );
	function StartFrame:OnClose() RunConsoleCommand( "disconnect" ); end
	StartFrame:SetTitle( "Client Settings" );
	StartFrame:SetSize( 500, 125 );
	StartFrame:Center();
	StartFrame:MakePopup();

	local StartLabel = StartFrame:Add( "DLabel" );
	StartLabel:SetText( "Welcome to the Lazer Zone client settings." );
	StartLabel:Dock( TOP );
	StartLabel:DockMargin( 0, 5, 0, 0 );
	StartLabel:SetContentAlignment( 5 );
	StartLabel:SizeToContents();

	local StartLabel = StartFrame:Add( "DLabel" );
	StartLabel:SetText( "Due to the design of the gamemode, you are not allowed to play in single-player." );
	StartLabel:Dock( TOP );
	StartLabel:SetContentAlignment( 5 );
	StartLabel:SizeToContents();

	local StartLabel = StartFrame:Add( "DLabel" );
	StartLabel:SetText( "If you want to continue into the client settings, click the button below." );
	StartLabel:Dock( TOP );
	StartLabel:SetContentAlignment( 5 );
	StartLabel:SizeToContents();

	local StartLabel = StartFrame:Add( "DLabel" );
	StartLabel:SetText( "If you want to leave, either close this window or disconnect from the session." );
	StartLabel:Dock( TOP );
	StartLabel:SetContentAlignment( 5 );
	StartLabel:SizeToContents();

	local StartButton = StartFrame:Add( "DButton" );
	function StartButton.DoClick() GAMEMODE:LoadSettingsMenu(); if ( IsValid( StartFrame ) ) then StartFrame:Remove(); StartFrame = nil; end end
	StartButton:SetText( "Continue" );
	StartButton:Dock( BOTTOM );

end


-- Load the settings menu
function GM:LoadSettingsMenu()

	local RandomStrings = {
		"Did you know daunknownfox2010 also worked on Prop Hunt: Enhanced?",
		"Lazer Zone is NOT a complete gamemode. Expect things to change!",
		"Lazer Zone's idea comes from an actual real-life lazer tag arena.",
		"Dark Zone + Lazer Blaze = Lazer Zone?",
		"Welcome to Perth, please mind the gap.",
		"*DING* DOORS CLOSING",
		"Furries! Furries! Furries!",
		"Not the Visual Novels! Anything but the Visual Novels! -/r/Steam",
		"OwO what's this?",
		"Obsidian Conflict is a better mod than Synergy.",
		"CHANGE MY MIND",
		"Join all the mainstream gamers, get Discord.",
		"Things that go ding."
	};

	local TempLabel = vgui.Create( "DLabel" );
	TempLabel:SetText( table.Random( RandomStrings ) );
	TempLabel:SizeToContents();
	TempLabel:Center();

	timer.Simple( 1, function() GAMEMODE:OpenSettingsMenu(); if ( IsValid( TempLabel ) ) then TempLabel:Remove(); TempLabel = nil; end end );

end


-- Open the settings menu
function GM:OpenSettingsMenu()

	local ToggleConVars = {
		[ "lz_cl_player_dynamic_lights" ] = "Dynamic Lights"
	};

	local MultiConVars = {
		[ "lz_cl_screen_scale" ] = { "Screen Scale", 0, 4 }
	};

	local SettingsFrame = vgui.Create( "DFrame" );
	function SettingsFrame:OnClose() RunConsoleCommand( "disconnect" ); end
	SettingsFrame:SetDraggable( false );
	SettingsFrame:SetTitle( "Client Settings" );
	SettingsFrame:SetSize( 640, 480 );
	SettingsFrame:Center()
	SettingsFrame:MakePopup();

	local SettingsPanel = SettingsFrame:Add( "DPanel" );
	SettingsPanel:SetBackgroundColor( Color( 150, 150, 150 ) );
	SettingsPanel:Dock( FILL );
	SettingsPanel:DockMargin( 0, 0, 0, 5 );

	local SettingsScrollPanel = SettingsPanel:Add( "DScrollPanel" );
	SettingsScrollPanel:Dock( FILL );

	local SettingsLabel = SettingsScrollPanel:Add( "DLabel" );
	SettingsLabel:SetFont( "DermaDefaultBold" );
	SettingsLabel:SetText( "-= Toggled Console Variables =-" );
	SettingsLabel:SetTextColor( Color( 255, 255, 255 ) );
	SettingsLabel:Dock( TOP );
	SettingsLabel:DockMargin( 0, 5, 0, 0 );
	SettingsLabel:SetContentAlignment( 5 );
	SettingsLabel:SizeToContents();

	for k, v in pairs( ToggleConVars ) do
	
		local SettingsCheckBoxPanel = SettingsScrollPanel:Add( "DPanel" );
		function SettingsCheckBoxPanel:Paint( w, h ) return; end
		SettingsCheckBoxPanel:Dock( TOP );
		SettingsCheckBoxPanel:DockMargin( 0, 0, 5, 0 );
	
		local SettingsCheckBox = SettingsCheckBoxPanel:Add( "DCheckBoxLabel" );
		SettingsCheckBox:SetText( v );
		SettingsCheckBox:SetTextColor( Color( 0, 0, 0 ) );
		SettingsCheckBox:SetConVar( k );
		SettingsCheckBox:SetValue( math.Clamp( GetConVarNumber( k ), 0, 1 ) );
		SettingsCheckBox:Dock( LEFT );
		SettingsCheckBox:DockMargin( 5, 0, 5, 0 );
		SettingsCheckBox:SizeToContents();
	
		local SettingsCheckBoxLabel = SettingsCheckBox:GetChild( 1 );
		SettingsCheckBoxLabel:Dock( RIGHT );
		SettingsCheckBoxLabel:SizeToContents();
	
	end

	local SettingsLabel = SettingsScrollPanel:Add( "DLabel" );
	SettingsLabel:SetFont( "DermaDefaultBold" );
	SettingsLabel:SetText( "-= Multiple Value Console Variables =-" );
	SettingsLabel:SetTextColor( Color( 255, 255, 255 ) );
	SettingsLabel:Dock( TOP );
	SettingsLabel:DockMargin( 0, 5, 0, 0 );
	SettingsLabel:SetContentAlignment( 5 );
	SettingsLabel:SizeToContents();

	for k, v in pairs( MultiConVars ) do
	
		local SettingsNumSliderPanel = SettingsScrollPanel:Add( "DPanel" );
		function SettingsNumSliderPanel:Paint( w, h ) return; end
		SettingsNumSliderPanel:Dock( TOP );
		SettingsNumSliderPanel:DockMargin( 0, 0, 5, 0 );
	
		local SettingsNumSlider = SettingsNumSliderPanel:Add( "DNumSlider" );
		SettingsNumSlider:SetText( v[ 1 ] );
		SettingsNumSlider:SetConVar( k );
		SettingsNumSlider:SetMax( v[ 3 ] );
		SettingsNumSlider:SetMin( v[ 2 ] );
		SettingsNumSlider:SetDecimals( 2 );
		SettingsNumSlider:SetValue( math.Clamp( GetConVarNumber( k ), v[ 2 ], v[ 3 ] ) );
		SettingsNumSlider:Dock( TOP );
		SettingsNumSlider:DockMargin( 5, 0, 5, 0 );
	
		local SettingsNumSliderLabel = SettingsNumSlider:GetChild( 2 );
		SettingsNumSliderLabel:SetTextColor( Color( 0, 0, 0 ) );
	
	end

	local RefreshButton = SettingsFrame:Add( "DButton" );
	function RefreshButton.DoClick() GAMEMODE:LoadSettingsMenu(); if ( IsValid( SettingsFrame ) ) then SettingsFrame:Remove(); SettingsFrame = nil; end end
	RefreshButton:SetText( "Refresh" );
	RefreshButton:Dock( BOTTOM );

end
