params [["_enabled", true]];
if (!hasInterface) exitWith {};

if (missionNamespace getVariable ["Spray_DMC_TeamSwitch_EH", -1] < 0) then {
	private _teamSwitchEH = addMissionEventHandler ["TeamSwitch", {
		params ["_previousUnit", "_newUnit"];
		[_newUnit] spawn {
			params ["_newUnit"];
			waitUntil {player == _newUnit};
			[["Spray_DMC_Hud_Enabled"] call CBA_settings_fnc_get] call Spray_DMC_fnc_Init;
		};
	}];
	missionNamespace setVariable ["Spray_DMC_TeamSwitch_EH", _teamSwitchEH];
};

[_enabled] spawn {
	params ["_enabled"];
	waitUntil {!isNull player};

	private _layer = "TAG_Spray_DMC_Hud" call BIS_fnc_rscLayer;
	private _handlers = uiNamespace getVariable ["Spray_DMC_Hud_EventHandlers", []];
	private _handlerUnit = _handlers param [0, objNull];
	if (!_enabled) exitWith {
		if (!isNull _handlerUnit) then {
			_handlerUnit removeEventHandler ["WeaponChanged", _handlers param [1, -1]];
			_handlerUnit removeEventHandler ["Reloaded", _handlers param [2, -1]];
		};
		uiNamespace setVariable ["Spray_DMC_Hud_EventHandlers", nil];
		_layer cutText ["", "PLAIN"];
	};

	if (_handlerUnit != player) then {
		if (!isNull _handlerUnit) then {
			_handlerUnit removeEventHandler ["WeaponChanged", _handlers param [1, -1]];
			_handlerUnit removeEventHandler ["Reloaded", _handlers param [2, -1]];
		};

		private _weaponEH = player addEventHandler ["WeaponChanged", {
			params ["_object", "_oldWeapon", "_newWeapon", "_oldMode", "_newMode", "_oldMuzzle", "_newMuzzle", "_turretIndex"];
			[_object, _newWeapon, _newMuzzle] call Spray_DMC_fnc_RefreshMan;
		}];
		private _reloadEH = player addEventHandler ["Reloaded", {
			params ["_unit", "_weapon", "_muzzle", "_newMagazine", "_oldMagazine"];
			[_unit, _weapon, _muzzle] call Spray_DMC_fnc_RefreshMan;
		}];
		uiNamespace setVariable ["Spray_DMC_Hud_EventHandlers", [player, _weaponEH, _reloadEH]];
	};

	_layer cutRsc ["Spray_DMC_Hud", "PLAIN"];
	uiSleep 0;
	[player, currentWeapon player, currentMuzzle player] call Spray_DMC_fnc_RefreshMan;
};
