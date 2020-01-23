# CustomFeats
A mod template that allows you to create custom feats in Forager via mods. Press TAB to view your feats and their progress.

## Concept
This mod template allows you to create custom feats that have their own names, descriptions, track progress per save-file, and view which feats are unlocked along with their progress in the custom UI. Provided are 3 example feats; one that instantly unlocks, one that unlocks after progress is being set for it, and one that unlocks via an update script.

## How To Use
1. Download the mod files from [here](https://github.com/nommiin/CustomFeats/archive/master.zip) and copy them into your mods directory!
2. Open ___Main.gml___ and modify the __Main__ event in the file
3. Create new feats by using the `FeatCreate` function
4. Note: You are free to delete both the `LICENSE` and `README` files, as they are GitHub-related files.

## How To Use In Your Mod
If you'd like to use CustomFeats in your already existing mod, then simply copy Feats.gml into your mod's directory. The GML file will automatically be loaded with your main script, just make sure to call the scripts prefixed with `__` (such as `__FeatMain`, `__FeatNewGame`, `__FeatLoad`) in their respective events (see "Event Functions" below)

## Mod Functions
This is an outline of each public function that can be used to create/edit feats in your own mod:
```js
/// @description Creates a feat with the given parameters
/// @argument name {string} The name of the feat to be displayed in-game
/// @argument description {string} The description feat to be displayed in-game
/// @argument check {script} The script that is ran every system step (20 frames), can be used to set progress/check progress or set as undefined to not call anything
/// @argument reward {script} The script that is ran upon completing the feat, can be undefined to not call anything
/// @returns {number} The numerical index tied to the feat, to be used with FeatUnlock/FeatSetProgress/etc
FeatCreate( name, description, check, reward )

/// @description Gets the current progress from 0..100 for the provided feat
/// @argument index {number} The numerical index tied to the feat you want to get the progress for
/// @returns {number|undefined} The progress value for the feat, will be undefined if the given feat does not exist
FeatGetProgress( index )

/// @description Sets progress value for the provided feat
/// @argument index {number} The numerical index tied to the feat you want to set the progress for
/// @argument progress {number} The progress value you want to set for the feat, between 0 and 100
/// @returns {boolean} If the progress was successfully set for the feat or not, will return false if the feat does not exist and true otherwise
FeatSetProgress( index, progress )

/// @description Adds an amount of progress onto the provided feat's progress value
/// @argument index {number} The numerical index tied to the feat you want to set the progress for
/// @argument progress {number} The amount of progress to add to the feat, between 0 and 100
/// @returns {boolean} If the progress was successfully added, will return false if the feat does not exist and true otherwise
FeatAddProgress( index )

/// @description Immediately sets the feat progress to 100, to be unlocked on the next system step, this will NOT run the reward script immediately
/// @argument index {number} The numerical index tied to the feat you want to unlock
/// @returns {boolean} If the progress was successfully added, will return false if the feat does not exist and true otherwise
FeatUnlock( index )
```

## Notes
* Update functions must have a redundant first argument in the script definition due to how `script_execute` functions, update functions should be defined like so for them to function properly: `#define MyFeatUpdate( _, progress )` (note the underscore argument)
* You are unable to set the feat icon and cosmetic reward sprites for the feat unlock popup due to how Forager functions internally
* Feats are tied to save files, it is reccomended that you create a new save file to test out your own feats.

## Event Functions
Below is a list of all the event functions with their respective Forager events they should be called in, ***these must*** be in your own mod otherwise CustomFeats will likely not function properly.
* `__FeatMain` -> Main
* `__FeatNewGame` -> OnNewGame
* `__FeatLoad` -> OnLoad
* `__FeatSystemStep` -> OnSystemStep
* `__FeatDrawGUI` -> OnDrawGUI

`__FeatPopulate` is not required, as both `__FeatNewGame` and `__FeatLoad` call this script internally.
