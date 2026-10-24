[
	"Spray_DMC_Hud_Enabled",
	"CHECKBOX",
	["Enable Detailed Magazine Counter", "Show or hide the magazine counter HUD."],
	["Detailed Magazine Counter"],
	true,
	0,
	{
		[_this] call Spray_DMC_fnc_Init;
	}
] call CBA_fnc_addSetting;

[
	"Spray_DMC_Hud_Fadeout",
	"TIME",
	["Fade out delay", "Seconds after the last counter update before fading out. Keybind available to manually refresh. Set 0 to disable."],
	["Detailed Magazine Counter"],
	[0, 60, 5],
	0,
	{
		
	}
] call CBA_fnc_addSetting;

["Detailed Magazine Counter", "Spray_DMC_Hud_RefreshKey", ["Display magazine counter", "Manually show magazine counter"], {
    [player, currentWeapon player, currentMuzzle player] call Spray_DMC_fnc_RefreshMan;
}, ""] call CBA_fnc_addKeybind;