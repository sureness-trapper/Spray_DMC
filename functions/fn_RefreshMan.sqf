params ["_object", "_weap", "_muzzle"];
private _hud = uiNamespace getVariable ["Spray_DMC_Hud", -1];
private _hudCtrl = (uiNamespace getVariable ["Spray_DMC_Hud", -1]) displayCtrl 1000;
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
    _hudCtrl ctrlSetText "";
};