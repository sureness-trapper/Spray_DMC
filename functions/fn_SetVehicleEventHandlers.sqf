params ["_vehicle", ["_addHandlers", false]];

private _eventHandlers = uiNamespace getVariable ["Spray_DMC_Hud_VehicleEventHandlers", []];
private _handlerVehicle = _eventHandlers param [0, objNull];
private _shouldAddHandlers = _addHandlers
    && {hasInterface}
    && {["Spray_DMC_Hud_Enabled"] call CBA_settings_fnc_get}
    && {!isNull _vehicle}
    && {_vehicle == vehicle player};

if (!_addHandlers && {
    !isNull _handlerVehicle && {isNull _vehicle || {_handlerVehicle == _vehicle}}
}) then {
    _handlerVehicle removeEventHandler ["WeaponChanged", _eventHandlers param [1, -1]];
    _handlerVehicle removeEventHandler ["Reloaded", _eventHandlers param [2, -1]];
    uiNamespace setVariable ["Spray_DMC_Hud_VehicleEventHandlers", nil];
    _handlerVehicle = objNull;
};

if (!_shouldAddHandlers || {!isNull _handlerVehicle}) exitWith {};

private _weaponChangedEH = _vehicle addEventHandler ["WeaponChanged", {
    private _vehicle = _this # 0;
    [_vehicle] call Spray_DMC_fnc_RefreshCurrent;
    
}];
private _reloadedEH = _vehicle addEventHandler ["Reloaded", {
    params ["_vehicle"];
    [_vehicle] call Spray_DMC_fnc_RefreshCurrent;
}];
uiNamespace setVariable ["Spray_DMC_Hud_VehicleEventHandlers", [
    _vehicle,
    _weaponChangedEH,
    _reloadedEH
]];
