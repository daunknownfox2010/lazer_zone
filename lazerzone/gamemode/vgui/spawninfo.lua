-- Spawn Info for preround

surface.CreateFont( "SpawnInfoDefault", {
	font	= "Roboto",
	size	= ScreenScale( 32 ),
	weight	= 800
} );

surface.CreateFont( "SpawnInfoSmall", {
	font	= "Roboto",
	size	= ScreenScale( 16 ),
	weight	= 800
} );

surface.CreateFont( "SpawnInfoExtraSmall", {
	font	= "Roboto",
	size	= ScreenScale( 12 ),
	weight	= 400
} );


local SPAWNINFO_PANEL = {

	Init = function( self )
	
		-- Requires local player
		if ( !IsValid( LocalPlayer() ) ) then
		
			self:Remove();
			return;
		
		end
	
		self:SetSize( ScrW(), ScrH() );
	
		self.Round = self:Add( "DLabel" );
		self.Round:SetText( "Round "..GetRoundNumber() );
		self.Round:SetFont( "SpawnInfoDefault" );
	
		if ( GAMEMODE.TeamBased ) then
		
			self.Team = self:Add( "DLabel" );
			self.Team:SetText( team.GetName( LocalPlayer():Team() ) );
			self.Team:SetFont( "SpawnInfoSmall" );
		
		end
	
		self.Starting = self:Add( "DLabel" );
		self.Starting:SetText( "The round will start shortly..." );
		self.Starting:SetFont( "SpawnInfoExtraSmall" );
	
		self.LifeTime = CurTime() + 4;
	
	end,

	Think = function( self )
	
		local w, h = self:GetSize();
	
		if ( self.Round != nil ) then
		
			local w2, h2 = self.Round:GetSize();
		
			self.Round:SetPos( ( w / 2 ) - ( w2 / 2 ), h / 2 - ScreenScale( 120 ) );
			self.Round:SetTextColor( Color( 255, 255, 255, math.Clamp( ( ( self.LifeTime - CurTime() ) / 1 ) * 255, 0, 255 ) ) );
			self.Round:SetSize( self.Round:GetTextSize() );
		
		end
	
		if ( GAMEMODE.TeamBased && ( self.Team != nil ) ) then
		
			local w2, hw = self.Team:GetSize();
		
			self.Team:SetPos( ( w / 2 ) - ( w2 / 2 ), h / 2 - ScreenScale( 80 ) );
			self.Team:SetTextColor( Color( GAMEMODE:GetTeamColor( LocalPlayer() ).r, GAMEMODE:GetTeamColor( LocalPlayer() ).g, GAMEMODE:GetTeamColor( LocalPlayer() ).b, math.Clamp( ( ( self.LifeTime - CurTime() ) / 1 ) * 255, 0, 255 ) ) );
			self.Team:SetSize( self.Team:GetTextSize() );
		
		end
	
		if ( self.Starting != nil ) then
		
			local w2, h2 = self.Starting:GetSize();
		
			self.Starting:SetPos( ( w / 2 ) - ( w2 / 2 ), h / 2 + ScreenScale( 80 ) );
			self.Starting:SetTextColor( Color( 255, 255, 255, math.Clamp( ( ( self.LifeTime - CurTime() ) / 1 ) * 255, 0, 255 ) ) );
			self.Starting:SetSize( self.Starting:GetTextSize() );
		
		end
	
		if ( self.LifeTime < CurTime() ) then self:Remove(); end
	
	end,

	Paint = function( self, w, h )
	
		surface.SetDrawColor( 0, 0, 0, math.Clamp( ( ( self.LifeTime - CurTime() ) / 1 ) * 255, 0, 255 ) );
		surface.DrawRect( 0, 0, w, h );
	
	end

};
vgui.Register( "SpawnInfo", SPAWNINFO_PANEL, "DPanel" );
