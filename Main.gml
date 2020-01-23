#define Main
__FeatMain();

// Define custom events and their respective events
global.FeatTreeDestroyer = FeatCreate("tree destroyer", "chop down a tree!", undefined, TreeDestroyerReward);
global.FeatSuperTreeDestroyer = FeatCreate("super tree destroyer", "chop down 3 trees!", undefined, SuperTreeDestroyerReward);
global.FeatSortaAddicted = FeatCreate("sorta addicted", "play the game for 5 minutes!", SortaAddictedUpdate, SortaAddictedReward);

#define TreeDestroyerReward
// When the "tree destroyer" feat is unlocked, the player will get 3 legendary gems
DropItem(objPlayer.x, objPlayer.y, Item.LegendaryGem, 3);

#define SuperTreeDestroyerReward
// When the "super tree destroyer" feat is unlocked, the player will get 6 legendary gems
DropItem(objPlayer.x, objPlayer.y, Item.LegendaryGem, 6);

#define SortaAddictedUpdate( _, progress )
// If an update script is provided, then it'll be called every 20 frames (can be used to check for items, gear, instances, etc)
// Any returned value from an update script will be set as the given feat's progress, but it is not required
return (variable_global_get("playTime") / 18000) * 100;

#define SortaAddictedReward
// When the "sorta addicted" feat is unlocked, the game will spawn a fairy at the player
instance_create_depth(objPlayer.x, objPlayer.y, objPlayer.depth, objFairy);

#define OnResourceDestroy( inst )
// An example of immediately unlocking a feat and updating a feat's progress
if (inst.object_index == objTree) {
    FeatUnlock(global.FeatTreeDestroyer);
    FeatAddProgress(global.FeatSuperTreeDestroyer, 100 / 3);
}

#define OnNewGame
__FeatNewGame();
#define OnLoad
__FeatLoad();
#define OnSystemStep
__FeatSystemStep();
#define OnDrawGUI
__FeatDrawGUI();