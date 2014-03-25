//
//  MahjonggAppDelegate.m
//  Mahjongg
//
//  Created by GamePipe Iphone Dev on 7/28/09.
//  Copyright USC 2009. All rights reserved.
//

#import "MahjonggAppDelegate.h"
#import "MenuScene.h"
#include "SimpleAudioEngine_objc.h"


#define MY_BANNER_UNIT_ID @"a152f5fd1fc166f"

void uncaughtExceptionHandler(NSException *exception) {

}

@implementation MahjonggAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
        // Analytics
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
        // View heirarchy setup
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window setUserInteractionEnabled:YES];
    [window setMultipleTouchEnabled:YES];
    [window makeKeyAndVisible];
    
    placeHolderViewController = [[UIViewController alloc] init];
    [window addSubview:placeHolderViewController.view];
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"opener.wav"];
    
    gameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [placeHolderViewController.view addSubview:gameView];

    
    soundOn = true;
        // Setup for high scores
	scoreManager = [[ScoreManager alloc] init];
	[scoreManager readBestTimes];
    if([ScoreManager _isGameCenterAvailable])
    {
        leaderboardController = [[GKLeaderboardViewController alloc] init];
    }
    else
    {
        //[gameCenterButton removeFromSuperview];
    }
    
        //[[Director sharedDirector] setLandscape:YES];
	[[Director sharedDirector] setDeviceOrientation:CCDeviceOrientationPortrait];
    [[Director sharedDirector] attachInView:gameView];
	
	MenuScene *scene = [MenuScene node];
	[[Director sharedDirector] runWithScene:scene];

    // Setup Ads if NOT Ad Free

    [[SimpleAudioEngine sharedEngine] preloadEffect:@"deselect.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"select.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"error.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"opener.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"removeTile.wav"];
    
    [self createAdBanner];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (ScoreManager*) getScoreMananger
{
    return scoreManager;
}

- (void) showLeaderboard
{
    if (leaderboardController != nil)
    {
        leaderboardController.leaderboardDelegate = self;
        [placeHolderViewController presentModalViewController: leaderboardController animated: YES];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [placeHolderViewController dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {

    [gameView release];
    [placeHolderViewController release];
    [scoreManager release];
    [leaderboardController release];
	[window release];
    [super dealloc];
}

-(void)createAdBanner {
    _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    _bannerView.delegate = self;
    CGRect bannerRc = _bannerView.frame;
    bannerRc.origin.y = gameView.bounds.size.height - bannerRc.size.height;
    _bannerView.frame = bannerRc;
    
    _bannerView.adUnitID = MY_BANNER_UNIT_ID;
    
    _bannerView.rootViewController = placeHolderViewController;
    [gameView addSubview:_bannerView];
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[GAD_SIMULATOR_ID];
    [_bannerView loadRequest:request];
}


- (void)adViewDidReceiveAd:(GADBannerView *)view {
    
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    
}

@end
