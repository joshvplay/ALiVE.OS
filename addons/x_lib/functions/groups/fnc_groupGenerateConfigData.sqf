#include "\x\alive\addons\x_lib\script_component.hpp"
SCRIPT(groupGenerateConfigData);

/* ----------------------------------------------------------------------------
Function: ALIVE_fnc_groupGenerateConfigData

Description:
Generates a config group hash to store path to config by group name and faction

Parameters:

Returns:


Examples:
(begin example)
[] call ALIVE_fnc_groupGenerateConfigData;
(end)

See Also:

Author:
ARJay
---------------------------------------------------------------------------- */

ALIVE_groupConfig = [] call ALIVE_fnc_hashCreate;

private _findRecurse = {
    private _root = (_this select 0);
    private _path = +(_this select 1);

    for "_i" from 0 to count _root -1 do {

        private _class = _root select _i;

        if (isClass _class) then {
            private _currentPath = _path + [_i];
            private _className = configName _class;

            if(count _currentPath == 4) then {
                // Hack to add support for factions
                private _configHierarchy = configHierarchy _class;
                private _faction = configname (_configHierarchy select 3);
                _className = format ["%1_%2", _faction, _className];
                [ALIVE_groupConfig, _className, [_configHierarchy select 0,_currentPath]] call ALIVE_fnc_hashSet;
            };

            [_class, _currentPath] call _findRecurse;
        };
    };
};

[missionConfigFile >> "CfgGroups", []] call _findRecurse;
[configFile >> "CfgGroups", []] call _findRecurse;

ALiVE_GROUP_CONFIG_DATA_GENERATED = true;