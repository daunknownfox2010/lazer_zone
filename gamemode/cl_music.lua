-- Lazer Zone by daunknownfox2010


-- Console Variables
local lz_cl_music_volume = CreateClientConVar( "lz_cl_music_volume", 0.4, true, false, "Change the music volume <0-1>." );


-- Adds the music path to the game
local LZMusicTable = {};
function GM:AddMusicPath( path, fileType )

	local searchPath = path;
	if ( string.Right( searchPath, 1 ) != "/" ) then searchPath = searchPath.."/"; end

	local searchPathFind = searchPath;
	if ( fileType == "wav" ) then
	
		searchPathFind = "sound/"..searchPath.."*.wav";
	
	elseif ( fileType == "mp3" ) then
	
		searchPathFind = "sound/"..searchPath.."*.mp3";
	
	else
	
		print( "No file type specified!" );
		return;
	
	end

	local fileList, folderList = file.Find( searchPathFind, "GAME" );
	for k, v in ipairs( fileList ) do
	
		util.PrecacheSound( searchPath..v );
	
		local index = #LZMusicTable + 1;
		LZMusicTable[ index ] = CreateSound( game.GetWorld(), searchPath..v );
		LZMusicTable[ index ]:SetSoundLevel( 0 );
		LZMusicTable[ index ]:Stop();
	
	end

end


-- Adds a specific music file to the game
function GM:AddMusicFile( searchFile )

	searchFilePath = "sound/"..searchFile

	if ( file.Exists( searchFilePath, "GAME" ) && ( ( string.Right( searchFilePath, 4 ) == ".wav" ) || ( string.Right( searchFilePath, 4 ) == ".mp3" ) ) ) then
	
		util.PrecacheSound( searchFile );
	
		local index = #LZMusicTable + 1;
		LZMusicTable[ index ] = CreateSound( game.GetWorld(), searchFile );
		LZMusicTable[ index ]:SetSoundLevel( 0 );
		LZMusicTable[ index ]:Stop();
	
	end

end


-- Plays or stops the music
function GM:RoundMusic( bool )

	if ( bool && ( #LZMusicTable > 0 ) ) then
	
		local chosenMusic = table.Random( LZMusicTable );
		chosenMusic:Play();
		chosenMusic:ChangeVolume( lz_cl_music_volume:GetFloat() );
	
	else
	
		for _, music in ipairs( LZMusicTable ) do
		
			music:Stop();
		
		end
	
	end

end


-- Debug purposes only
function GM:PrintMusicTable()

	PrintTable( LZMusicTable );

end


-- Network round music
function LZNETRoundMusic( len )

	GAMEMODE:RoundMusic( net.ReadBool() );

end
net.Receive( "LZNETRoundMusic", LZNETRoundMusic );
