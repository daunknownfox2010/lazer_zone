-- Timer

surface.CreateFont( "TimerDefault", {
	font	= "Verdana",
	size	= ControlledScreenScale( 12 ),
	weight	= 400
} );

surface.CreateFont( "TimerTime", {
	font	= "Impact",
	size	= ControlledScreenScale( 32 ),
	weight	= 200
} );


local TIMER_PANEL = {

	Init = function( self )
	
		self:SetPos( ( ScrW() / 2 ) - ( ControlledScreenScale( 100 ) / 2 ), 15 );
		self:SetSize( ControlledScreenScale( 100 ), ControlledScreenScale( 50 ) );
	
		self.Time = self:Add( "DLabel" );
		self.Time:SetFont( "TimerDefault" );
		self.Time:SetText( "Time" );
		self.Time:Dock( TOP );
		self.Time:DockMargin( 0, 2.5, 0, 0 );
		self.Time:SetContentAlignment( 5 );
		self.Time:SizeToContents();
	
		self.TimeLeft = self:Add( "DLabel" );
		self.TimeLeft:SetFont( "TimerTime" );
		self.TimeLeft:SetText( string.ToMinutesSeconds( "0" ) );
		self.TimeLeft:SetTextColor( Color( 255, 255, 255 ) );
		self.TimeLeft:Dock( FILL );
		self.TimeLeft:SetContentAlignment( 5 );
		self.TimeLeft:SizeToContents();
	
	end,

	Think = function( self )
	
		if ( !IsValid( LocalPlayer() ) ) then return; end
	
		if ( self.TimeLeft != nil ) then
		
			if ( !IsRoundState( ROUND_PREROUND ) && ( GetRoundTime() >= CurTime() ) ) then
			
				self.TimeLeft:SetText( string.ToMinutesSeconds( GetRoundTime() - CurTime() ) );
				self.TimeLeft:SizeToContents();
			
			else
			
				self.TimeLeft:SetText( string.ToMinutesSeconds( "0" ) );
				self.TimeLeft:SizeToContents();
			
			end
		
		end
	
	end,

	Paint = function( self, w, h )
	
		draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) );
	
	end

};
vgui.Register( "Timer", TIMER_PANEL, "DPanel" );
