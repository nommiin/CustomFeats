#define Main
__FeatMain();

global.FeatTreeDestroyer = FeatCreate("tree destroyer", "chop down a tree!", undefined, TreeDestroyerReward);
global.FeatSuperTreeDestroyer = FeatCreate("super tree destroyer", "chop down 3 trees!", undefined, SuperTreeDestroyerReward);

#define OnResourceDestroy( inst )
if (inst.object_index == objTree) {
    FeatUnlock(global.FeatTreeDestroyer);
    FeatAddProgress(global.FeatSuperTreeDestroyer, 100 / 3);
}

#define TreeDestroyerReward
DropItem(objPlayer.x, objPlayer.y, Item.LegendaryGem, 3);

#define SuperTreeDestroyerReward
DropItem(objPlayer.x, objPlayer.y, Item.LegendaryGem, 6);

#define OnNewGame
__FeatNewGame();
#define OnLoad
__FeatLoadGame();
#define OnSystemStep
__FeatSystemStep();
#define OnDrawGUI
__FeatDrawGUI();