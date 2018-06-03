-- Lazer Zone by daunknownfox2010

AddCSLuaFile();

local meta = FindMetaTable( "Player" );
if ( !meta ) then return; end


-- Console Variables
local lz_sh_powerups_enabled = CreateConVar( "lz_sh_powerups_enabled", 1, { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "Enables player power-ups." );
local lz_sh_powerups_nuke = CreateConVar( "lz_sh_powerups_nuke", 1, { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "Enables the nuke power-up." );


-- Add score
function meta:AddScore( score )

	if ( CLIENT ) then return; end

	self:AddFrags( score );
	self:SetNWInt( "LZScore", self:GetNWInt( "LZScore" ) + score );

end


-- Set score
function meta:SetScore( score )

	if ( CLIENT ) then return; end

	self:SetFrags( score );
	self:SetNWInt( "LZScore", score );

end


-- Get frags
function meta:Frags()

	return self:GetNWInt( "LZScore" );

end


-- Set Deactivation
local PlayerActivatedSound = Sound( "LazerZone.PlayerActivated" );
local PlayerDeactivatedSound = Sound( "LazerZone.PlayerDeactivated" );
function meta:SetDeactivated( bool, playSound )

	if ( CLIENT ) then return; end

	self:SetNoDraw( bool );

	if ( IsValid( self:GetActiveWeapon() ) ) then
	
		self:GetActiveWeapon():SetNoDraw( bool );
	
	end
	
	if ( bool ) then
	
		self.deactivatedTime = CurTime() + math.random( 6, 8 );
	
		if ( playSound ) then
		
			self:EmitSound( PlayerDeactivatedSound );
		
		end
	
		self:SetLaggedMovementValue( 1.25 );
	
		self.statusEffectTime = 0;
	
	else
	
		if ( playSound ) then
		
			self:EmitSound( PlayerActivatedSound );
		
		end
	
		self:SetLaggedMovementValue( 1 );
	
		if ( self:HoldingLazer() ) then self:GetActiveWeapon():SetNextPrimaryFire( CurTime() + 0.6 ); end
	
	end

	self:SetNWBool( "LZDeactivated", bool );

end


-- Get Deactivation
function meta:Deactivated()

	return self:GetNWBool( "LZDeactivated" );

end


-- Set Stamina
function meta:SetStamina( stamina )

	if ( CLIENT ) then return; end

	self:SetNWFloat( "LZStamina", stamina );

end


-- Get Stamina
function meta:Stamina()

	return self:GetNWFloat( "LZStamina", 100 );

end


-- Set Exhausted
function meta:SetExhausted( bool )

	if ( CLIENT ) then return; end

	self:SetNWBool( "LZExhausted", bool );

end


-- Get Exhausted
function meta:Exhausted()

	return self:GetNWBool( "LZExhausted" );

end


-- Set status effect
STATUS_NONE = 0;
STATUS_RAPIDFIRE = 1;
STATUS_INVINCIBLE = 2;
STATUS_INVISIBLE = 3;
STATUS_NUKE = 4;	-- Absolute BS status tbh
local PlayerInvincibilitySound = Sound( "LazerZone.PlayerInvincibility" );
local PlayerInvisibilitySound = Sound( "LazerZone.PlayerInvisibility" );
local PlayerNukeSound = Sound( "LazerZone.PlayerNuke" );
local PlayerRapidFireSound = Sound( "LazerZone.PlayerRapidFire" );
function meta:SetStatusEffect( num )

	if ( CLIENT ) then return; end
	if ( !num ) then return; end
	if ( ( num < 0 ) || ( num > 4 ) ) then return; end
	if ( !lz_sh_powerups_enabled:GetBool() ) then return; end

	if ( num == STATUS_NONE ) then
	
		-- Rapid fire relies on changing the lazer gun fire rate attribute
		if ( self:GetStatusEffect() == STATUS_RAPIDFIRE ) then
		
			if ( self:HoldingLazer() ) then
			
				self:GetActiveWeapon().Primary.FireRate = self:GetActiveWeapon().Primary.DefaultFireRate;
			
			end
		
		end
	
	elseif ( num == STATUS_RAPIDFIRE ) then
	
		self.statusEffectTime = CurTime() + 30;
	
		if ( self:HoldingLazer() ) then
		
			self:GetActiveWeapon().Primary.FireRate = self:GetActiveWeapon().Primary.DefaultFireRate / 2;
		
		end
	
		self:EmitSound( PlayerRapidFireSound );
	
		net.Start( "LZNETInformationText" );
			net.WriteString( "RAPID FIRE ENABLED!" );
			net.WriteInt( 3, 4 );
		net.Broadcast();
	
	elseif ( num == STATUS_INVINCIBLE ) then
	
		self.statusEffectTime = CurTime() + 10;
	
		self:EmitSound( PlayerInvincibilitySound );
	
		net.Start( "LZNETInformationText" );
			net.WriteString( "INVINCIBILITY ENABLED!" );
			net.WriteInt( 3, 4 );
		net.Broadcast();
	
	elseif ( num == STATUS_INVISIBLE ) then
	
		self.statusEffectTime = CurTime() + 15;
	
		self:EmitSound( PlayerInvisibilitySound );
	
		net.Start( "LZNETInformationText" );
			net.WriteString( "INVISIBILITY ENABLED!" );
			net.WriteInt( 3, 4 );
		net.Broadcast();
	
	elseif ( num == STATUS_NUKE ) then
	
		-- Nuke disabled
		if ( !lz_sh_powerups_nuke:GetBool() ) then
		
			self:SetStatusEffect( math.random( 1, 3 ) );
			return;
		
		end
	
		self.statusEffectTime = CurTime() + 3;
	
		self:EmitSound( PlayerNukeSound );
	
		net.Start( "LZNETInformationText" );
			net.WriteString( "NUKE ENABLED!" );
			net.WriteInt( 2, 4 );
		net.Broadcast();
	
	end

	self:SetNWInt( "LZStatusEffect", num );

end


-- Get status effect
function meta:GetStatusEffect()

	return self:GetNWInt( "LZStatusEffect" );

end


-- Has status effect
function meta:HasStatusEffect( num )

	return ( num == self:GetNWInt( "LZStatusEffect" ) );

end


-- Is the player holding the lazer gun
function meta:HoldingLazer()

	return ( IsValid( self:GetActiveWeapon() ) && ( self:GetActiveWeapon():GetClass() == "weapon_lazergun" ) );

end


-- Player is spectating
function meta:IsSpectating()

	return ( ( GAMEMODE.TeamBased && ( self:Team() == TEAM_UNASSIGNED ) ) || ( self:Team() == TEAM_SPECTATOR ) );

end


-- Get player color structure
function meta:GetPlayerColorStructure()

	return Color( self:GetPlayerColor().x * 255, self:GetPlayerColor().y * 255, self:GetPlayerColor().z * 255, 255 );

end
