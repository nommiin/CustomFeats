#define Main
global.featIndex = 0;
global.featOffset = 1000;
global.featData = ds_list_create();
global.featSave = undefined;

// Example Feat
global.FeatTree = FeatCreate("tree destroyer", "destroy a tree!", undefined, FeatTreeReward);
global.FeatAddicted = FeatCreate("sort of addicted", "play for 5 minutes", FeatAddicted, undefined);

// Example Feat Progress
#define FeatAddicted(_, progress)
return (variable_global_get("playTime") / 18000) * 100;

// Example Feat Unlock
#define OnResourceDestroy(inst)
if (inst.object_index == objTree) {
    FeatSetProgress(global.FeatTree, 100);
}

// Example Feat Reward
#define FeatTreeReward()
DropItem(objPlayer.x, objPlayer.y, Item.LegendaryGem, 3);

#region Mod Functions
#define FeatCreate( name, description, check, reward )
var _featObject = {
    Index: global.featOffset + global.featIndex,
    Name: name,
    Description: description,
    Check: check,
    Reward: reward,
    SaveID: string_lower(string_replace_all(name, " ", "_"))
};
ds_list_add(global.featData, _featObject);
LocalizationAddKey("english", "featName" + string(global.featOffset + global.featIndex), name);
LocalizationAddKey("english", "featDesc" + string(global.featOffset + global.featIndex), description);
return global.featOffset + global.featIndex++;

#define FeatInitalize()
for(var i = 0; i < ds_list_size(global.featData); i++) {
    var _featGet = global.featData[| i];
    if (ds_map_exists(global.featSave, _featGet.SaveID + ":progress") == false) {
        global.featSave[? _featGet.SaveID + ":unlocked"] = false;
        global.featSave[? _featGet.SaveID + ":progress"] = 0;
    }
}

#define FeatGetProgress( index )
var _featGet = global.featData[| index - global.featOffset];
if (_featGet != undefined) {
   return ds_map_find_value(global.featSave, _featGet.SaveID + ":progress");
}

#define FeatSetProgress( index, progress )
var _featGet = global.featData[| index - global.featOffset];
if (_featGet != undefined) {
    global.featSave[? _featGet.SaveID + ":progress"] = progress;
}
#endregion
#region Event Hooks
#define OnNewGame
global.featSave = ds_map_create();
FeatInitalize();

#define OnLoad
global.featSave = ModSaveDataFetch();
FeatInitalize();

#define OnSystemStep
// Update feat progress and set unlock if so
if (instance_exists(objPlayer) == true) {
    for(var i = 0; i < ds_list_size(global.featData); i++) {
        var _featGet = global.featData[| i];
        if (global.featSave[? _featGet.SaveID + ":unlocked"] == false) {
            if (_featGet.Check != undefined) {
                var _featReturn = script_execute(_featGet.Check, global.featSave[? _featGet.SaveID + ":progress"], undefined);
                if (_featReturn != 0) {
                    global.featSave[? _featGet.SaveID + ":progress"] = _featReturn;
                }
            }
            
            if (global.featSave[? _featGet.SaveID + ":progress"] >= 100) {
                if (_featGet.Reward != undefined) {
                    script_execute(_featGet.Reward);
                }
                audio_play_sound(sndFeatUnlocked, 0, false);
                global.featSave[? _featGet.SaveID + ":unlocked"] = true;
                ModSaveDataSubmit(global.featSave);
                WorldControl.feat[0] = _featGet.Index;
                WorldControl.feat[1] = room_speed * 5;
            }
        }
    }
}

#define OnDrawGUI
// Render the feats screen
if (keyboard_check(9) == true && instance_exists(objPlayer) == true) {
    draw_set_alpha(0.5);
    draw_rectangle_color(0, 0, 1280, 720, c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    var _featColour = make_colour_rgb(222, 167, 61);
    draw_text_transformed_color((1280 / 2) + 9, 64 - 18, "custom feats", 2, 2, 0, _featColour, _featColour, _featColour, _featColour, 1);
    draw_line_width_colour((1280 / 2) - 256, 96, (1280 / 2) + 256, 96, 3, c_white, c_white);
    var _featOffset = {x: (1280 / 2) - (1280 / 3), y: 172};
    for(var i = 0; i < ds_list_size(global.featData); i++) {
        var _featGet = global.featData[| i];
        draw_set_alpha(0.3);
        draw_rectangle_colour(_featOffset.x - 164, _featOffset.y - 64, _featOffset.x + 164, _featOffset.y + 64, c_black, c_black, c_black, c_black, false);
        draw_set_alpha(1);
        draw_set_valign(fa_top);
        draw_text(_featOffset.x + 9, (_featOffset.y + 9) - 58, _featGet.Name);
        draw_text_ext_transformed(_featOffset.x + 6.75, (_featOffset.y + 9) - 36, _featGet.Description, -1, 328, 0.75, 0.75, 0);
        var _featProgress = FeatGetProgress(i + global.featOffset);
        draw_line_width_colour(_featOffset.x - 148, _featOffset.y + 32, _featOffset.x + 148, _featOffset.y + 32, 9, c_dkgray, c_dkgray);
        draw_line_width_colour(_featOffset.x - 148, _featOffset.y + 32, (_featOffset.x - 148) + ((148 * 2) * (_featProgress / 100)), _featOffset.y + 32, 9, _featColour, _featColour);
        draw_set_halign(fa_middle);
        draw_text_transformed(_featOffset.x + 11.25, _featOffset.y + 30, string(min(100, round(_featProgress))) + "%", 1.25, 1.25, 0);
        if (i % 3 == 2) {
            _featOffset.x = (1280 / 2) - (1280 / 3);
            _featOffset.y += 164;
        } else {
            _featOffset.x += (1280 / 3);
        }
    }
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
}
#endregion