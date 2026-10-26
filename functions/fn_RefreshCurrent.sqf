params [
    "_vehicle"
];
if (!hasInterface || {isNull player} || {!(["Spray_DMC_Hud_Enabled"] call CBA_settings_fnc_get)} || {!(_vehicle in [vehicle player, player])}) exitWith {};
private _hud = uiNamespace getVariable ["Spray_DMC_Hud", displayNull];
if (isNull _hud) exitWith {};

if (_vehicle == player) exitWith {
    [player] call Spray_DMC_fnc_Refresh;
};

private _crewInfo = (fullCrew _vehicle) select {
    (_x # 0) isEqualTo player
};
private _crew = _crewInfo param [0, []];
if (_crew isEqualTo [] || {(_crew param [1, ""]) == "cargo"}) exitWith {
    (_hud displayCtrl 1000) ctrlSetStructuredText parseText "";
};
if (_crew param [4, false]) exitWith {
    [player] call Spray_DMC_fnc_Refresh;
};
private _turretPath = _crew param [3, []];
if (_turretPath isEqualTo []) then {
    _turretPath = [-1];
};
[_vehicle, _turretPath] call Spray_DMC_fnc_Refresh;
