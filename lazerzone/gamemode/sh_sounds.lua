-- Lazer Zone by daunknownfox2010

AddCSLuaFile();


-- Base Damage
sound.Add( {
	name = "LazerZone.BaseDamage",
	channel = CHAN_ITEM,
	volume = 0.75,
	level = 75,
	pitch = 100,
	sound = "lazerzone/basepoint/lz_basedamage.wav"
} );


-- Base Destroy
sound.Add( {
	name = "LazerZone.BaseDestroy",
	channel = CHAN_ITEM,
	volume = 1,
	level = 75,
	pitch = 100,
	sound = "lazerzone/basepoint/lz_basedestroy.wav"
} );


-- Base Ping
sound.Add( {
	name = "LazerZone.BasePing",
	channel = CHAN_ITEM,
	volume = 0.5,
	level = 65,
	pitch = 100,
	sound = "lazerzone/basepoint/lz_baseping.wav"
} );


-- Player Activated
sound.Add( {
	name = "LazerZone.PlayerActivated",
	channel = CHAN_VOICE,
	volume = 1,
	level = 60,
	pitch = 100,
	sound = "lazerzone/player/lz_activated.wav"
} );


-- Player Deactivated
sound.Add( {
	name = "LazerZone.PlayerDeactivated",
	channel = CHAN_VOICE,
	volume = 1,
	level = 60,
	pitch = 100,
	sound = { "lazerzone/player/lz_down1.wav", "lazerzone/player/lz_down2.wav" }
} );


-- Player Ranking First
sound.Add( {
	name = "LazerZone.PlayerRankingFirst",
	channel = CHAN_VOICE,
	volume = 1,
	level = 60,
	pitch = 100,
	sound = "lazerzone/player/ranking/lz_first.wav"
} );


-- Player Ranking Second
sound.Add( {
	name = "LazerZone.PlayerRankingSecond",
	channel = CHAN_VOICE,
	volume = 1,
	level = 60,
	pitch = 100,
	sound = "lazerzone/player/ranking/lz_second.wav"
} );


-- Player Ranking Third
sound.Add( {
	name = "LazerZone.PlayerRankingThird",
	channel = CHAN_VOICE,
	volume = 1,
	level = 60,
	pitch = 100,
	sound = "lazerzone/player/ranking/lz_third.wav"
} );


-- Player Invincibility
sound.Add( {
	name = "LazerZone.PlayerInvincibility",
	channel = CHAN_VOICE,
	volume = 1,
	level = 60,
	pitch = 100,
	sound = "lazerzone/player/status/lz_invincibility.wav"
} );


-- Player Invisibility
sound.Add( {
	name = "LazerZone.PlayerInvisibility",
	channel = CHAN_VOICE,
	volume = 1,
	level = 60,
	pitch = 100,
	sound = "lazerzone/player/status/lz_invisibility.wav"
} );


-- Player Nuke
sound.Add( {
	name = "LazerZone.PlayerNuke",
	channel = CHAN_VOICE,
	volume = 1,
	level = 60,
	pitch = 100,
	sound = "lazerzone/player/status/lz_nuke.wav"
} );


-- Player Rapid Fire
sound.Add( {
	name = "LazerZone.PlayerRapidFire",
	channel = CHAN_VOICE,
	volume = 1,
	level = 60,
	pitch = 100,
	sound = "lazerzone/player/status/lz_rapidfire.wav"
} );


-- Lazer Gun
sound.Add( {
	name = "LazerZone.LazerGun",
	channel = CHAN_WEAPON,
	volume = 0.75,
	level = 140,
	pitch = 100,
	sound = "lazerzone/weapons/lz_lazergun.wav"
} );
