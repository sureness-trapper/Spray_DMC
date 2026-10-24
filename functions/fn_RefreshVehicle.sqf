params ["_vehicle", "_turretPath"];
if !(["Spray_DMC_Hud_Enabled"] call CBA_settings_fnc_get) exitWith {};
if (isNull player || {isNull _vehicle} || {vehicle player != _vehicle}) exitWith {};

private _hud = uiNamespace getVariable ["Spray_DMC_Hud", displayNull];
if (isNull _hud) exitWith {};

private _hudCtrl = _hud displayCtrl 1000;
private _fadeoutDelay = ["Spray_DMC_Hud_Fadeout"] call CBA_settings_fnc_get;
uiNamespace setVariable ["Spray_DMC_Hud_Fadeout_Time", (time + _fadeoutDelay)];
_hudCtrl ctrlSetFade 0;
_hudCtrl ctrlCommit 0;

private _weapon = _vehicle currentWeaponTurret _turretPath;
private _muzzle = (weaponState [_vehicle, _turretPath]) param [1, ""];
private _loadedMag = _vehicle currentMagazineTurret _turretPath;
private _vehicleMagazines = _vehicle magazinesTurret [_turretPath, false];
private _includeCurrMag = ["Spray_DMC_Hud_IncludeCurrMag"] call CBA_settings_fnc_get;
private _compatibleMags = [];
if (_weapon != "") then {
    _compatibleMags = compatibleMagazines [_weapon, _muzzle];
};

private _mags = _compatibleMags arrayIntersect _vehicleMagazines;
private _showCounter = count _mags > 1;
if (_includeCurrMag != 2 && {_loadedMag != ""}) then {
    private _loadedMagIndex = _vehicleMagazines find _loadedMag;
    if (_loadedMagIndex >= 0) then {
        private _singleShotMag = getNumber (configFile >> "CfgMagazines" >> _loadedMag >> "count") == 1;
        if (_includeCurrMag == 0 || !_singleShotMag) then {
            _vehicleMagazines deleteAt _loadedMagIndex;
        };
    };
};

_mags = _compatibleMags arrayIntersect _vehicleMagazines;
private _str = "";
if (_showCounter) then {
    {
        private _magazine = _x;
        private _magCount = {_x == _magazine} count _vehicleMagazines;
        _str = _str + format [
            "%1 |%2<br/>",
            getText (configFile >> "CfgMagazines" >> _magazine >> "displayName"),
            str _magCount
        ];
    } forEach _mags;
    _hudCtrl ctrlSetStructuredText parseText _str;
} else {
    _hudCtrl ctrlSetStructuredText parseText "";
};

if (_fadeoutDelay > 0 && {_str != ""}) then {
    [_hudCtrl, _fadeoutDelay] spawn {
        params ["_hudCtrl", "_fadeoutDelay"];
        sleep _fadeoutDelay;
        if (!isNull _hudCtrl && {
            uiNamespace getVariable ["Spray_DMC_Hud_Fadeout_Time", 0] <= time
        }) then {
            _hudCtrl ctrlSetFade 1;
            _hudCtrl ctrlCommit 1;
        };
    };
};
