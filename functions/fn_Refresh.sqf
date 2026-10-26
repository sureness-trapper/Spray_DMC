params [
    "_object",
    ["_turretPath", []]
];
if !(["Spray_DMC_Hud_Enabled"] call CBA_settings_fnc_get) exitWith {};
if (isNull player || {isNull _object}) exitWith {};
private _hud = uiNamespace getVariable ["Spray_DMC_Hud", displayNull];
if (isNull _hud) exitWith {};

private _hudCtrl = _hud displayCtrl 1000;
private _fadeoutDelay = ["Spray_DMC_Hud_Fadeout"] call CBA_settings_fnc_get;
private _includeCurrMag = ["Spray_DMC_Hud_IncludeCurrMag"] call CBA_settings_fnc_get;
private _showAmmoPercentage = ["Spray_DMC_Hud_AmmoCounter"] call CBA_settings_fnc_get;
uiNamespace setVariable ["Spray_DMC_Hud_Fadeout_Time", (time + _fadeoutDelay)];
_hudCtrl ctrlSetFade 0;
_hudCtrl ctrlCommit 0;
private _weapon = "";
private _muzzle = "";
private _magazines = [];
private _loadedMag = [];

if (_object == player) then {
    _weapon = currentWeapon _object;
    _muzzle = currentMuzzle _object;
    _magazines = magazinesAmmoFull _object select {_x # 0 in compatibleMagazines [_weapon, _muzzle]};
    _loadedMag = (_magazines select {_x # 2}) # 0;
    if (isNil "_loadedMag") then {_loadedMag = []};
} else {
    _weapon = _object currentWeaponTurret _turretPath;
    _muzzle = (weaponState [_object, _turretPath]) param [1, ""];
    _magazines = magazinesAllTurrets [_object, true] select {_x # 0 in compatibleMagazines [_weapon, _muzzle] && _x # 1 isEqualTo _turretPath && _x # 2 > 0} apply {[_x # 0, _x # 2]};
    _loadedMag = weaponState [_object, _turretPath] select [3, 2];
    if (_loadedMag isEqualTo ["", 0]) then {_loadedMag = []};
};
private _magTypes = {(_magazines apply {_x # 0}) arrayIntersect (_magazines apply {_x # 0})};
private _str = "";
if (count (call _magTypes) > 1) then {
    if (_includeCurrMag != 2 && {_loadedMag isNotEqualTo []}) then {
        private _singleShotMag = getNumber (configFile >> "CfgMagazines" >> (_loadedMag # 0) >> "count") == 1;
        if (_includeCurrMag == 0 || !_singleShotMag) then {
            _magazines deleteAt (_magazines find _loadedMag);
        };
    };
    {
        private _magazine = _x;
        private _magazineAll = _magazines select {(_x # 0) == _magazine};
        private _magCount = count _magazineAll;
        private _ammoPercent = "";
        if (_showAmmoPercentage) then {
            private _maxAmmo = getNumber (configFile >> "CfgMagazines" >> _magazine >> "count") * _magCount;
            private _remainingAmmo = 0;
            {
                _remainingAmmo = _remainingAmmo + (_x # 1);
            } forEach _magazineAll;
            _remainingAmmo = round (100 * _remainingAmmo / _maxAmmo);
            _ammoPercent = if (_remainingAmmo < 100) then {
               format [" %1%%", str _remainingAmmo];
            } else {
                ""
            };
        };
        _str = _str + format [
            "%1 |%2%3<br/>",
            getText (configFile >> "CfgMagazines" >> _magazine >> "displayName"),
            str _magCount,
            _ammoPercent
        ];
    } forEach (call _magTypes);
};
_hudCtrl ctrlSetStructuredText parseText _str;


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