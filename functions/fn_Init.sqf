if (!hasInterface) exitWith {};

[] spawn {
	waitUntil {!isNull player};
	("TAG_Spray_DMC_Hud" call BIS_fnc_rscLayer) cutRsc ["Spray_DMC_Hud", "PLAIN"];
	player addEventHandler ["WeaponChanged", {
		params ["_object", "_oldWeapon", "_newWeapon", "_oldMode", "_newMode", "_oldMuzzle", "_newMuzzle", "_turretIndex"];
		[_object, _newWeapon, _newMuzzle] call Spray_DMC_fnc_RefreshMan;
	}];
	player addEventHandler ["Reloaded", {
		params ["_unit", "_weapon", "_muzzle", "_newMagazine", "_oldMagazine"];
		[_unit, _weapon, _muzzle] call Spray_DMC_fnc_RefreshMan;
	}];
};
