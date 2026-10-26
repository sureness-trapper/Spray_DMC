[
	"Spray_DMC_Hud_Enabled",
	"CHECKBOX",
	["Enable", "Show or hide the magazine counter HUD."],
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
		if (hasInterface && {!isNull vehicle player}) then {
			[vehicle player] call Spray_DMC_fnc_RefreshCurrent;
		};
	}
] call CBA_fnc_addSetting;

[
	"Spray_DMC_Hud_IncludeCurrMag",
	"LIST",
	["Include loaded magazine", "Include currently loaded magazine in the count."],
	["Detailed Magazine Counter"],
	[[1, 0, 2], ["Single shot magazine only", "Disabled", "Enabled"], 0],
	0,
	{
		if (hasInterface && {!isNull vehicle player}) then {
			[vehicle player] call Spray_DMC_fnc_RefreshCurrent;
		};
	}
] call CBA_fnc_addSetting;

[
	"Spray_DMC_Hud_AmmoCounter",
	"CHECKBOX",
	["% of ammo left per type", "Show remaining rounds as a percentage for each magazine type. Loaded magazines included if the count is."],
	["Detailed Magazine Counter"],
	true,
	0,
	{
		if (hasInterface && {!isNull vehicle player}) then {
			[vehicle player] call Spray_DMC_fnc_RefreshCurrent;
		};
	}
] call CBA_fnc_addSetting;

["Detailed Magazine Counter", "Spray_DMC_Hud_RefreshKey", ["Display magazine counter", "Manually show magazine counter"], {
	if (hasInterface && {!isNull vehicle player}) then {
		[vehicle player] call Spray_DMC_fnc_RefreshCurrent;
	};
}, ""] call CBA_fnc_addKeybind;