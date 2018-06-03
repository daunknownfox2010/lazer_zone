-- Score Info

surface.CreateFont( "ScoreInfoDefault", {
	font	= "Verdana",
	size	= ControlledScreenScale( 12 ),
	weight	= 400
} );


local SCOREINFO_PANEL = {

	Init = function( self )
	
		self:SetPos( 15, 15 );
	
		if ( GAMEMODE.TeamBased ) then
		
			self:SetSize( ControlledScreenScale( 200 ), ControlledScreenScale( 100 ) );
		
		else
		
			self:SetSize( ControlledScreenScale( 200 ), ControlledScreenScale( 40 ) );
		
		end
	
		self.Scores = self:Add( "DLabel" );
		self.Scores:SetText( "Scores" );
		self.Scores:SetFont( "ScoreInfoDefault" );
		self.Scores:Dock( TOP );
		self.Scores:DockMargin( 0, 2.5, 0, 0 );
		self.Scores:SetContentAlignment( 5 );
		self.Scores:SizeToContents();
	
		self.YourScore = self:Add( "DLabel" );
		self.YourScore:SetPos( ControlledScreenScale( 5 ), ControlledScreenScale( 20 ) );
		self.YourScore:SetText( "Your Score: 000000000000" );
		self.YourScore:SetTextColor( Color( 255, 255, 255 ) );
		self.YourScore:SetFont( "ScoreInfoDefault" );
		self.YourScore:SizeToContents();
		self.YourScore.SavedScore = 0;
		self.YourScore.RefreshScore = 0;
	
		if ( GAMEMODE.TeamBased ) then
		
			self.BlueScore = self:Add( "DLabel" );
			self.BlueScore:SetPos( ControlledScreenScale( 5 ), ControlledScreenScale( 40 ) );
			self.BlueScore:SetText( "Blue Score: 000000000000" );
			self.BlueScore:SetTextColor( Color( 0, 150, 255 ) );
			self.BlueScore:SetFont( "ScoreInfoDefault" );
			self.BlueScore:SizeToContents();
			self.BlueScore.SavedScore = 0;
			self.BlueScore.RefreshScore = 0;
		
			self.RedScore = self:Add( "DLabel" );
			self.RedScore:SetPos( ControlledScreenScale( 5 ), ControlledScreenScale( 60 ) );
			self.RedScore:SetText( "Red Score: 000000000000" );
			self.RedScore:SetTextColor( Color( 255, 0, 0 ) );
			self.RedScore:SetFont( "ScoreInfoDefault" );
			self.RedScore:SizeToContents();
			self.RedScore.SavedScore = 0;
			self.RedScore.RefreshScore = 0;
		
			self.YellowScore = self:Add( "DLabel" );
			self.YellowScore:SetPos( ControlledScreenScale( 5 ), ControlledScreenScale( 80 ) );
			self.YellowScore:SetText( "Yellow Score: 00000000000" );
			self.YellowScore:SetTextColor( Color( 255, 255, 0 ) );
			self.YellowScore:SetFont( "ScoreInfoDefault" );
			self.YellowScore:SizeToContents();
			self.YellowScore.SavedScore = 0;
			self.YellowScore.RefreshScore = 0;
		
		end
	
	end,

	Think = function( self )
	
		if ( !IsValid( LocalPlayer() ) ) then return; end
	
		if ( self.YourScore != nil ) then
		
			if ( self.YourScore.SavedScore != LocalPlayer():Frags() ) then
			
				self.YourScore.SavedScore = LocalPlayer():Frags();
				self.YourScore.RefreshScore = CurTime() + 0.5;
			
			end
		
			if ( self.YourScore.RefreshScore < CurTime() ) then
			
				self.YourScore:SetText( "Your Score: "..self.YourScore.SavedScore );
			
			else
			
				self.YourScore:SetText( "Your Score: "..math.random( 100000000, 900000000 ) );
			
			end
		
		end
	
		if ( GAMEMODE.TeamBased && ( self.BlueScore != nil ) ) then
		
			if ( self.BlueScore.SavedScore != team.GetScore( TEAM_BLUE ) ) then
			
				self.BlueScore.SavedScore = team.GetScore( TEAM_BLUE );
				self.BlueScore.RefreshScore = CurTime() + 0.5;
			
			end
		
			if ( self.BlueScore.RefreshScore < CurTime() ) then
			
				self.BlueScore:SetText( "Blue Score: "..self.BlueScore.SavedScore );
			
			else
			
				self.BlueScore:SetText( "Blue Score: "..math.random( 100000000, 900000000 ) );
			
			end
		
		end
	
		if ( GAMEMODE.TeamBased && ( self.RedScore != nil ) ) then
		
			if ( self.RedScore.SavedScore != team.GetScore( TEAM_RED ) ) then
			
				self.RedScore.SavedScore = team.GetScore( TEAM_RED );
				self.RedScore.RefreshScore = CurTime() + 0.5;
			
			end
		
			if ( self.RedScore.RefreshScore < CurTime() ) then
			
				self.RedScore:SetText( "Red Score: "..self.RedScore.SavedScore );
			
			else
			
				self.RedScore:SetText( "Red Score: "..math.random( 100000000, 900000000 ) );
			
			end
		
		end
	
		if ( GAMEMODE.TeamBased && ( self.YellowScore != nil ) ) then
		
			if ( self.YellowScore.SavedScore != team.GetScore( TEAM_YELLOW ) ) then
			
				self.YellowScore.SavedScore = team.GetScore( TEAM_YELLOW );
				self.YellowScore.RefreshScore = CurTime() + 0.5;
			
			end
		
			if ( self.YellowScore.RefreshScore < CurTime() ) then
			
				self.YellowScore:SetText( "Yellow Score: "..self.YellowScore.SavedScore );
			
			else
			
				self.YellowScore:SetText( "Yellow Score: "..math.random( 100000000, 900000000 ) );
			
			end
		
		end
	
	end,

	Paint = function( self, w, h )
	
		draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) );
	
	end

};
vgui.Register( "ScoreInfo", SCOREINFO_PANEL, "DPanel" );
