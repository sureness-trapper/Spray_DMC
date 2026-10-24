class RscStructuredText;
class CfgPatches {
    class Spray_DMC {
        units[] = {};
        weapons[] = {};
        magazines[] = {};
        requiredVersion = 0.100000;
        requiredAddons[] = {"A3_UI_F", "cba_main"};
    };
};
class CfgFunctions {
    class Spray_DMC {
        class Spray_DMC {
            file = "Spray_DMC\functions";
            class RefreshMan {
            };
            class RefreshVehicle {
            };
            class RefreshCurrent {
            };
            class SetVehicleEventHandlers {
            };
            class PreInit {
                preInit = 1;
            };
            class Init {
            };
        };
    };
};
class CfgUIGrids {
    class IGUI {
        class Presets {
            class Arma3 {
                class Variables {
                    grid_Spray_DMC_Hud[] = {
                        {
                            "0.675",
                            "-0.2",
                            "1",
                            "1"
                        },
                        "(((safeZoneW / safeZoneH) min 1.2) / 40)",
                        "((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)"
                    };
                };
            };
        };
        class Variables {
            class grid_Spray_DMC_Hud {
                displayName = "Detailed Magazine Counter";
                description = "Magazine Counter Location";
                preview = "#(argb,8,8,3)color(0.2,0.2,0.2,0.5)";
                saveToProfile[] = {0, 1, 2, 3};
                canResize = 1;
            };
        };
    };
};
class RscTitles {
    class Spray_DMC_Hud {
        idd = -1;
        duration = 1e10;
        fadeIn = 0;
        fadeOut = 0;
		onLoad = "uiNamespace setVariable ['Spray_DMC_Hud', _this select 0];";
        class controls {
            class HudText : RscStructuredText {
                idc = 1000;
                text = "";
                x = "(profilenamespace getVariable ['IGUI_grid_Spray_DMC_Hud_X', 0.675])";
                y = "(profilenamespace getVariable ['IGUI_grid_Spray_DMC_Hud_Y', -0.2])";
                w = "(profilenamespace getVariable ['IGUI_grid_Spray_DMC_Hud_W', 1])";
                h = "(profilenamespace getVariable ['IGUI_grid_Spray_DMC_Hud_H', 1])";
                size = 0.03;
                colorBackground[] = {0, 0, 0, 0};
                class Attributes {
                    font = "RobotoCondensed";
                    color = "#FFFFFF";
                    align = "right";
                    shadow = 0;
                };
            };
        };
    };
};
