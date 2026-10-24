params ["_object", "_weap", "_muzzle"];
if !(["Spray_DMC_Hud_Enabled"] call CBA_settings_fnc_get) exitWith {};

private _hud = uiNamespace getVariable ["Spray_DMC_Hud", displayNull];
if (isNull _hud) exitWith {};

private _hudCtrl = _hud displayCtrl 1000;
private _fadeoutDelay = ["Spray_DMC_Hud_Fadeout"] call CBA_settings_fnc_get;
uiNamespace setVariable ["Spray_DMC_Hud_Fadeout_Time", (time + _fadeoutDelay)];
_hudCtrl ctrlSetFade 0;
_hudCtrl ctrlCommit 0;

private _objMags = magazines _object;
private _mags = compatibleMagazines [_weap, _muzzle] arrayIntersect _objMags;
private _str = "";
if (count _mags > 1) then {
    {
        private _y = _x;
        _str = _str + format ["%1 |%2<br/>", getText (configFile >> "CfgMagazines" >> _x >> "displayName"), str ({_y == _x} count _objMags)];
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