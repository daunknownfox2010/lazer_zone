-- Lazer Gun Tracer

EFFECT.Mat = Material( "effects/laser1" );
EFFECT.Muzzle = Material( "effects/yellowflare" );


function EFFECT:Init( data )

	self.Position = data:GetStart();
	self.WeaponEnt = data:GetEntity();
	self.WeaponOwner = data:GetEntity():GetOwner();
	self.Attachment = data:GetAttachment();

	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment );
	self.EndPos = data:GetOrigin();

	self.Alpha = 255;
	self.Life = 0;

	self.Color = Color( 255, 255, 255 );

	if ( IsValid( self.WeaponOwner ) && self.WeaponOwner:IsPlayer() ) then
	
		self.Color = self.WeaponOwner:GetPlayerColorStructure();
	
	end

	self:SetRenderBoundsWS( self.StartPos, self.EndPos );

end


function EFFECT:Think()

	self.Life = self.Life + FrameTime() * 4;
	self.Alpha = 255 * ( 1 - self.Life );

	return ( self.Life < 1 );

end


function EFFECT:Render()

	if ( self.Alpha < 1 ) then return; end

	render.SetMaterial( self.Muzzle );

	render.DrawSprite( self.StartPos, 16, 16, self.Color );

	render.SetMaterial( self.Mat );
	local texcoord = math.Rand( 0, 1 );

	local norm = ( self.StartPos - self.EndPos ) * self.Life;

	self.Length = norm:Length();

	for i = 1, 3 do
	
		render.DrawBeam( self.StartPos - norm, self.EndPos, 8, texcoord, texcoord + self.Length / 128, self.Color );
	
	end

	render.DrawBeam( self.StartPos, self.EndPos, 4, texcoord, texcoord + ( ( self.StartPos - self.EndPos ):Length() / 128 ), Color( self.Color.r, self.Color.g, self.Color.b, 255 * ( 1 - self.Life ) ) );

end
