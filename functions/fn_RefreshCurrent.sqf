params [
    ["_eventVehicle", objNull],
    ["_eventWeapon", ""],
    ["_eventMuzzle", ""]
];
private _hasVehicleEvent = count _this > 0;
if !(["Spray_DMC_Hud_Enabled"] call CBA_settings_fnc_get) exitWith {};
if (isNull player) exitWith {};

private _vehicle = vehicle player;
if (_hasVehicleEvent && {_vehicle != _eventVehicle}) exitWith {};
if (_vehicle == player) exitWith {
    [] call Spray_DMC_fnc_RefreshMan;
};

private _crewInfo = (fullCrew _vehicle) select {
    (_x # 0) isEqualTo player
};
private _crew = _crewInfo param [0, []];
if (_crew isEqualTo [] || {(_crew param [1, ""]) == "cargo"}) exitWith {
    if (!_hasVehicleEvent) then {
        private _hud = uiNamespace getVariable ["Spray_DMC_Hud", displayNull];
        if (!isNull _hud) then {
            (_hud displayCtrl 1000) ctrlSetStructuredText parseText "";
        };
    };
};
if (_crew param [4, false]) exitWith {
    if (!_hasVehicleEvent) then {
        [] call Spray_DMC_fnc_RefreshMan;
    };
};

private _turretPath = _crew param [3, []];
if (_turretPath isEqualTo []) then {
    _turretPath = [-1];
};
if (_hasVehicleEvent && {
    _eventWeapon != (_vehicle currentWeaponTurret _turretPath)
        || {_eventMuzzle != ((weaponState [_vehicle, _turretPath]) param [1, ""])}
}) exitWith {};
[_vehicle, _turretPath] call Spray_DMC_fnc_RefreshVehicle;
