-- Lazer Gun

SWEP.PrintName = "#weapon_lazergun";
SWEP.UseHands = true;

SWEP.ViewModelFOV = 62;
SWEP.ViewModelFlip = false;
SWEP.ViewModel = "models/weapons/cstrike/c_pist_glock18.mdl";
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl";

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = -1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "none";
SWEP.Primary.FireRate = 0.6;
SWEP.Primary.DefaultFireRate = 0.6;

SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none";

SWEP.Weight = 1;
SWEP.AutoSwitchTo = false;
SWEP.AutoSwitchFrom = false;

SWEP.Slot = 0;
SWEP.SlotPos = 0;
SWEP.DrawAmmo = false;
SWEP.DrawCrosshair = true;

local WeaponSound = Sound( "LazerZone.LazerGun" );


-- Initialize the weapon
function SWEP:Initialize()

		self:SetHoldType( "pistol" );

end


-- Primary attack
function SWEP:PrimaryAttack()

	if ( !self.Owner:IsPlayer() || self.Owner:Deactivated() ) then return; end

	self.Weapon:EmitSound( WeaponSound );

	self:ShootLazer();

	self:SetNextPrimaryFire( CurTime() + self.Primary.FireRate );

end


-- Secondary attack
function SWEP:SecondaryAttack()

	return;

end


-- Shoot lazer
function SWEP:ShootLazer()

	if ( self.Owner:IsPlayer() ) then
	
		self.Owner:LagCompensation( true );
	
		local trace = self.Owner:GetEyeTrace();
	
		self.Owner:LagCompensation( false );
	
		if ( trace.Hit ) then
		
			if ( IsValid( trace.Entity ) ) then
			
				local damageInfo = DamageInfo();
				damageInfo:SetAttacker( self.Owner );
				damageInfo:SetInflictor( self.Weapon );
				damageInfo:SetDamage( 0 );
			
				trace.Entity:DispatchTraceAttack( damageInfo, trace );
			
			end
		
			if ( IsFirstTimePredicted() ) then
			
				local lazerEffect = EffectData();
				lazerEffect:SetEntity( self.Weapon );
				lazerEffect:SetOrigin( trace.HitPos );
				lazerEffect:SetAttachment( 1 );
				util.Effect( "lazerguntracer", lazerEffect );
			
			end
		
		end
	
	end

end


-- Translate player activity
function SWEP:TranslateActivity( act )

	if ( self.Owner:IsNPC() ) then
	
		if ( self.ActivityTranslateAI[ act ] ) then
		
			return self.ActivityTranslateAI[ act ];
		
		end
	
		return -1;
	
	end

	if ( self.ActivityTranslate[ act ] != nil ) then
	
		if ( self.ActivityTranslate[ act ] == ACT_HL2MP_IDLE_PISTOL ) then self.ActivityTranslate[ act ] = ACT_HL2MP_IDLE_REVOLVER; end
		if ( self.ActivityTranslate[ act ] == ACT_HL2MP_WALK_PISTOL ) then self.ActivityTranslate[ act ] = ACT_HL2MP_WALK_REVOLVER; end
		if ( self.ActivityTranslate[ act ] == ACT_HL2MP_RUN_PISTOL ) then self.ActivityTranslate[ act ] = ACT_HL2MP_RUN_REVOLVER; end
		return self.ActivityTranslate[ act ];
	
	end

	return -1;

end
