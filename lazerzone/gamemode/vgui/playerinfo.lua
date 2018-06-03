-- Player Info

surface.CreateFont( "PlayerInfoName", {
	font	= "Roboto Light",
	size	= ControlledScreenScale( 22 ),
	extended = true,
	weight	= 800
} );

surface.CreateFont( "PlayerInfoStatus", {
	font	= "Roboto Thin",
	size	= ControlledScreenScale( 16 ),
	extended = true,
	weight	= 400
} );


local PLAYERINFO_PANEL = {

	Init = function( self )
	
		self:SetPos( 15, ScrH() - ControlledScreenScale( 46 ) - 15 );
		self:SetSize( ControlledScreenScale( 280 ), ControlledScreenScale( 46 ) );
	
		self.AvatarPanel = self:Add( "DPanel" );
		self.AvatarPanel:SetPos( ControlledScreenScale( 5 ), ControlledScreenScale( 5 ) )
		self.AvatarPanel:SetSize( ControlledScreenScale( 36 ), ControlledScreenScale( 36 ) )
	
		self.AvatarImage = vgui.Create( "AvatarImage", self.AvatarPanel );
		self.AvatarImage:SetPos( ControlledScreenScale( 2 ), ControlledScreenScale( 2 ) );
		self.AvatarImage:SetSize( ControlledScreenScale( 32 ), ControlledScreenScale( 32 ) );
	
		if ( ControlledScreenScale( 32 ) <= 32 ) then
		
			self.AvatarImage:SetPlayer( LocalPlayer(), 32 );
		
		elseif ( ControlledScreenScale( 32 ) <= 64 ) then
		
			self.AvatarImage:SetPlayer( LocalPlayer(), 64 );
		
		else
		
			self.AvatarImage:SetPlayer( LocalPlayer(), 184 );
		
		end
	
		self.PlayerName = self:Add( "DLabel" );
		self.PlayerName:SetPos( ControlledScreenScale( 5 ) + ControlledScreenScale( 36 ) + ControlledScreenScale( 10 ), ControlledScreenScale( 5 ) );
		self.PlayerName:SetText( "-==================-" );
		self.PlayerName:SetTextColor( Color( 255, 255, 255 ) );
		self.PlayerName:SetFont( "PlayerInfoName" );
		self.PlayerName:SizeToContents();
	
		self.PlayerStatus = self:Add( "DLabel" );
		self.PlayerStatus:SetPos( ControlledScreenScale( 5 ) + ControlledScreenScale( 36 ) + ControlledScreenScale( 10 ), ControlledScreenScale( 25 ) );
		self.PlayerStatus:SetText( "-========================-" );
		self.PlayerStatus:SetFont( "PlayerInfoStatus" );
		self.PlayerStatus:SizeToContents();
	
	end,

	Think = function( self )
	
		if ( !IsValid( LocalPlayer() ) ) then return; end
	
		local setVisible = !LocalPlayer():IsSpectating();
	
		if ( self.AvatarPanel != nil ) then
		
			self.AvatarPanel:SetVisible( setVisible );
			self.AvatarPanel:SetBackgroundColor( LocalPlayer():GetPlayerColorStructure() );
		
		end
	
		if ( self.AvatarImage != nil ) then
		
			self.AvatarImage:SetVisible( setVisible );
		
		end
	
		if ( self.PlayerName != nil ) then
		
			self.PlayerName:SetVisible( setVisible );
			self.PlayerName:SetText( LocalPlayer():Nick() );
		
		end
	
		if ( self.PlayerStatus != nil ) then
		
			self.PlayerStatus:SetVisible( setVisible );
		
			if ( IsRoundState( ROUND_INROUND ) && LocalPlayer():Deactivated() ) then
			
				self.PlayerStatus:SetText( "DEAD" );
			
			elseif ( LocalPlayer():HasStatusEffect( STATUS_RAPIDFIRE ) ) then
			
				self.PlayerStatus:SetText( "Rapid Fire" );
			
			elseif ( LocalPlayer():HasStatusEffect( STATUS_INVINCIBLE ) ) then
			
				self.PlayerStatus:SetText( "Invincible" );
			
			elseif ( LocalPlayer():HasStatusEffect( STATUS_INVISIBLE ) ) then
			
				self.PlayerStatus:SetText( "Invisible" );
			
			elseif ( LocalPlayer():HasStatusEffect( STATUS_NUKE ) ) then
			
				self.PlayerStatus:SetText( "Nuke" );
			
			else
			
				self.PlayerStatus:SetText( "No Status Effect" );
			
			end
		
		end
	
	end,

	Paint = function( self, w, h )
	
		if ( !IsValid( LocalPlayer() ) ) then return; end
		if ( LocalPlayer():IsSpectating() ) then return; end
	
		draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) );
	
	end

};
vgui.Register( "PlayerInfo", PLAYERINFO_PANEL, "DPanel" );
