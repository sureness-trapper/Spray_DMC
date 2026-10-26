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
		[objNull, false] call Spray_DMC_fnc_SetVehicleEventHandlers;

		if (!isNull _handlerUnit) then {
			{
				_handlerUnit removeEventHandler [_x # 0, _handlers param [_x # 1, -1]];
			} forEach [
				["WeaponChanged", 1],
				["Reloaded", 2],
				["GetInMan", 3],
				["GetOutMan", 4],
				["SeatSwitchedMan", 5]
			];
		};
		uiNamespace setVariable ["Spray_DMC_Hud_EventHandlers", nil];
		_layer cutText ["", "PLAIN"];
	};

	private _refreshEH = {
		params ["_unit"];
		[_unit] call Spray_DMC_fnc_RefreshCurrent;
	};
	private _getInEH = {
		params ["_unit", "_role", "_vehicle"];
		[_vehicle, true] call Spray_DMC_fnc_SetVehicleEventHandlers;
		[_vehicle] call Spray_DMC_fnc_RefreshCurrent;
		
	};
	private _getOutEH = {
		params ["_unit", "_role", "_vehicle"];
		[_vehicle, false] call Spray_DMC_fnc_SetVehicleEventHandlers;
		[_unit] call Spray_DMC_fnc_RefreshCurrent;
	};
	private _seatSwitchedEH = {
		params ["_unit1", "_unit2", "_vehicle"];
		[_vehicle] call Spray_DMC_fnc_RefreshCurrent;
	};

	if (_handlerUnit != player) then {
		[objNull, false] call Spray_DMC_fnc_SetVehicleEventHandlers;
		if (!isNull _handlerUnit) then {
			{
				_handlerUnit removeEventHandler [_x # 0, _handlers param [_x # 1, -1]];
			} forEach [
				["WeaponChanged", 1],
				["Reloaded", 2],
				["GetInMan", 3],
				["GetOutMan", 4],
				["SeatSwitchedMan", 5]
			];
		};

		private _weaponEHId = player addEventHandler ["WeaponChanged", _refreshEH];
		private _reloadEHId = player addEventHandler ["Reloaded", _refreshEH];
		private _getInEHId = player addEventHandler ["GetInMan", _getInEH];
		private _getOutEHId = player addEventHandler ["GetOutMan", _getOutEH];
		private _seatSwitchedEHId = player addEventHandler ["SeatSwitchedMan", _seatSwitchedEH];
		uiNamespace setVariable ["Spray_DMC_Hud_EventHandlers", [
			player,
			_weaponEHId,
			_reloadEHId,
			_getInEHId,
			_getOutEHId,
			_seatSwitchedEHId
		]];
	};

	_layer cutRsc ["Spray_DMC_Hud", "PLAIN"];
	uiSleep 0;
	if (vehicle player != player) then {
		[vehicle player, true] call Spray_DMC_fnc_SetVehicleEventHandlers;
	};
	call _refreshEH;
};
