-- Lazer Base Point

AddCSLuaFile();

ENT.Type = "anim";

ENT.TeamID = 0;
ENT.IdleSkinTime = 0;
ENT.DamagedStreak = 0;
ENT.DamagedTime = 0;
ENT.DamagedBy = Player( 0 );
ENT.DamagedByTime = 0;
ENT.Killed = false;
ENT.KilledTime = 0;
ENT.KilledBy = {};

local BaseDamageSound = Sound( "LazerZone.BaseDamage" );
local BaseDestroySound = Sound( "LazerZone.BaseDestroy" );
local BasePingSound = Sound( "LazerZone.BasePing" );
local BaseUnderAttack = Sound( "lazerzone/basepoint/lz_baseunderattack.wav" );


-- Entity initialize
function ENT:Initialize()

	self:DrawShadow( false );
	self:SetModel( "models/combine_helicopter/helicopter_bomb01.mdl" );
	self:SetModelScale( 0.75 );

	-- Reinitalize these variables
	self.KilledBy = {};

	if ( SERVER ) then
	
		self:PhysicsInit( SOLID_VPHYSICS );
		self:SetMoveType( MOVETYPE_NONE );
		self.Entity:CollisionRulesChanged();
	
		self:PhysWake();
	
	end

end


-- Entity key values
function ENT:KeyValue( key, value )

	if ( GAMEMODE.TeamBased && ( string.lower( key ) == "teamid" ) ) then
	
		self.TeamID = tonumber( value );
	
	end

	if ( ( string.lower( key ) == "ondamaged" ) || ( string.lower( key ) == "ondestroyed" ) ) then
	
		self:StoreOutput( string.lower( key ), value );
	
	end

end


-- Entity think
function ENT:Think()

	if ( SERVER ) then
	
		-- Change the skin while idle
		if ( !self.Killed && ( self.IdleSkinTime < CurTime() ) ) then
		
			if ( self:GetSkin() == 0 ) then
			
				self:SetSkin( 1 );
			
			else
			
				self:SetSkin( 0 );
			
			end
		
			if ( self.DamagedTime < CurTime() ) then
			
				self.IdleSkinTime = CurTime() + 1;
			
				if ( self:GetSkin() == 0 ) then self.Entity:EmitSound( BasePingSound ); end
			
			else
			
				self.IdleSkinTime = CurTime() + 0.01;
			
			end
		
		end
	
		-- Killed respawn time
		if ( self.Killed && ( self.KilledTime < CurTime() ) ) then
		
			self.Killed = false;
		
		end
	
		-- Erase the damaged by player if they have not shot this for a while
		if ( IsValid( self.DamagedBy ) && ( self.DamagedByTime < CurTime() ) ) then
		
			self.DamagedBy = Player( 0 );
		
		end
	
		self:NextThink( CurTime() );
	
	end

end


-- Entity takes damage
local mp_friendlyfire = GetConVar( "mp_friendlyfire" );
function ENT:OnTakeDamage( info )

	-- Prevent attack while damaged time is active or is killed
	if ( self.Killed ) then return; end
	if ( self.DamagedTime >= CurTime() ) then return; end

	-- Attacker and Inflictor
	local attacker = info:GetAttacker();
	local inflictor = info:GetInflictor();

	-- Attacker is a player
	if ( IsValid( attacker ) && attacker:IsPlayer() && attacker:HoldingLazer() ) then
	
		-- Prevent friendly fire
		if ( ( self.TeamID == attacker:Team() ) && !mp_friendlyfire:GetBool() ) then return; end
	
		-- Prevent further damage by a player that has killed the base already
		if ( self.KilledBy[ attacker:SteamID() ] ) then return; end
	
		self.DamagedByTime = CurTime() + 2;
	
		if ( self.DamagedBy == attacker ) then
		
			self.DamagedStreak = self.DamagedStreak + 1;
		
		else
		
			self.DamagedBy = attacker;
			self.DamagedStreak = 1;
		
			if ( self.TeamID != TEAM_CONNECTING ) then
			
				-- Play a sound for the team
				for _, ply in ipairs( team.GetPlayers( self.TeamID ) ) do
				
					net.Start( "LZNETPlaySound" );
						net.WriteString( BaseUnderAttack );
					net.Send( ply );
				
				end
			
				-- Display information text
				net.Start( "LZNETInformationText" );
					net.WriteString( string.upper( team.GetName( self.TeamID ) ).."'S BASE IS UNDER ATTACK" );
					net.WriteInt( 2, 4 );
				net.Broadcast();
			
			end
		
		end
	
		if ( self.DamagedStreak >= 3 ) then
		
			self.KilledTime = CurTime() + 30;
			self.Killed = true;
		
			self:SetSkin( 1 );
		
			self.KilledBy[ attacker:SteamID() ] = true;
		
			if ( self.TeamID != attacker:Team() ) then
			
				attacker:AddScore( 1000 );
				team.AddScore( attacker:Team(), 1000 );
			
			else
			
				attacker:AddScore( -750 );
				team.AddScore( attacker:Team(), -750 );
			
			end
		
			-- Kill streak
			if ( !GAMEMODE.TeamBased || ( self.TeamID != attacker:Team() ) ) then attacker.killStreak = attacker.killStreak + 4; end
		
			-- Attacker kill streak handling
			if ( attacker:HasStatusEffect( STATUS_NONE ) && ( attacker.killStreak >= attacker.killStreakReq ) ) then
			
				attacker.killStreak = 0;
				if ( attacker.killStreakReq < 15 ) then
				
					attacker.killStreakReq = attacker.killStreakReq + 5;
				
				end
			
				attacker:SetStatusEffect( math.random( 1, 4 ) );
			
			end
		
			if ( self.TeamID != TEAM_CONNECTING ) then
			
				-- Display information text
				net.Start( "LZNETInformationText" );
					net.WriteString( attacker:Nick().." DESTROYED "..string.upper( team.GetName( self.TeamID ) ).."'S BASE" );
					net.WriteInt( 4, 4 );
				net.Broadcast();
			
			end
		
			self.Entity:EmitSound( BaseDestroySound );
		
			self:TriggerOutput( "ondestroyed", attacker );
		
		else
		
			self.Entity:EmitSound( BaseDamageSound );
			self.DamagedTime = CurTime() + 1;
			self.IdleSkinTime = 0;
		
			self:TriggerOutput( "ondamaged", attacker );
		
		end
	
	end

end
