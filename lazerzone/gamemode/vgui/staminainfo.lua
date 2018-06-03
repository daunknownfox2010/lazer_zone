-- Stamina Info

surface.CreateFont( "StaminaInfoDefault", {
	font	= "Verdana",
	size	= ControlledScreenScale( 12 ),
	weight	= 400
} );


local STAMINAINFO_PANEL = {

	Init = function( self )
	
		self:SetPos( 15, ScrH() - 15 - ControlledScreenScale( 46 ) - ControlledScreenScale( 35 ) - 5 );
		self:SetSize( ControlledScreenScale( 200 ), ControlledScreenScale( 35 ) );
	
		self.PosUpdate = 0;
		self.PosX = 15;
		self.PosXLerp = 15;
	
		self.Stamina = self:Add( "DLabel" );
		self.Stamina:SetText( "Stamina" );
		self.Stamina:SetFont( "StaminaInfoDefault" );
		self.Stamina:Dock( TOP );
		self.Stamina:DockMargin( 5, 2.5, 0, 0 );
		self.Stamina:SizeToContents();
	
		self.StaminaBar = self:Add( "DPanel" );
		self.StaminaBar:Dock( FILL );
		self.StaminaBar:DockMargin( 5, 2.5, 5, 5 );
		self.StaminaBar.Paint = function( self, w, h )
		
			draw.RoundedBox( 2, 0, 0, ( ( LocalPlayer():Stamina() / 100 ) * w ), h, Color( 255, 255, 255, 255 ) );
		
		end
	
	end,

	Think = function( self )
	
		if ( !IsValid( LocalPlayer() ) ) then return; end
	
		local setVisible = !LocalPlayer():IsSpectating();
	
		if ( self.Stamina != nil ) then
		
			self.Stamina:SetVisible( setVisible );
		
		end
	
		if ( self.StaminaBar != nil ) then
		
			self.StaminaBar:SetVisible( setVisible );
		
		end
	
		if ( LocalPlayer():Stamina() >= 100 ) then
		
			self.PosX =  -15 - ControlledScreenScale( 200 );
		
		else
		
			self.PosX = 15;
		
		end
	
		if ( ( self.PosX != nil ) && ( self.PosUpdate < CurTime() ) ) then
		
			self.PosUpdate = CurTime() + 0.01;
		
			if ( self.PosXLerp != nil ) then
			
				self.PosX = ( self.PosX * 0.15 ) + ( self.PosXLerp * 0.85 );
			
			end
		
			self:SetPos( self.PosX, ScrH() - 15 - ControlledScreenScale( 46 ) - ControlledScreenScale( 35 ) - 5 );
		
			self.PosXLerp = self.PosX;
		
		end
	
	end,

	Paint = function( self, w, h )
	
		if ( !IsValid( LocalPlayer() ) ) then return; end
		if ( LocalPlayer():IsSpectating() ) then return; end
	
		draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) );
	
	end

};
vgui.Register( "StaminaInfo", STAMINAINFO_PANEL, "DPanel" );
