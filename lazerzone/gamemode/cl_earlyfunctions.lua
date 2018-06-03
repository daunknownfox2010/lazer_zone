-- Lazer Zone by daunknownfox2010


-- Console Variables
local lz_cl_screen_scale = CreateClientConVar( "lz_cl_screen_scale", 1, true, false, "Scales screen elements with 0 being automatic (useful for higher resolutions)." );


-- Alternative ScreenScale
function ControlledScreenScale( num )

	local scale = lz_cl_screen_scale:GetFloat();

	-- 0 is automatic
	if ( !lz_cl_screen_scale:GetBool() ) then
	
		-- Automatic scaling is clamped for reasons
		scale = math.Clamp( ScrW() / 1280, 1, 3 );
	
	end

	return ( num * scale );

end
