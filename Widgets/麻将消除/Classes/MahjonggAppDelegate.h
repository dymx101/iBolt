//
//  MahjonggAppDelegate.h
//  Mahjongg
//
//  Created by GamePipe Iphone Dev on 7/28/09.
//  Copyright USC 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreManager.h"
#import "GADBannerView.h"

@interface MahjonggAppDelegate : NSObject
<UIApplicationDelegate
, GKLeaderboardViewControllerDelegate
, GADBannerViewDelegate> {
    UIWindow *window;
    UIViewController *placeHolderViewController;
    UIView *gameView;
    @public ScoreManager* scoreManager;
    GKLeaderboardViewController *leaderboardController;
    BOOL soundOn;
}

@property (nonatomic, strong) GADBannerView *bannerView;

- (void) showLeaderboard;
- (ScoreManager*) getScoreMananger;

@end

