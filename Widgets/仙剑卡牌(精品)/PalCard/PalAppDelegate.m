//
//  PalAppDelegate.m
//  PalCard
//
//  Created by FlyinGeek on 13-1-28.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalAppDelegate.h"
#import "PalDataInit.h"

#define MY_BANNER_UNIT_ID @"a152f5fd1fc166f"

@implementation PalAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [PalDataInit gameDataInit];
    
    [PalUtil appStoreVersionCheck];
    
    [self createAdBanner];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

-(void)createAdBanner {
    _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    _bannerView.delegate = self;
    
    _bannerView.adUnitID = MY_BANNER_UNIT_ID;
    
    _bannerView.rootViewController = _window.rootViewController;
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[GAD_SIMULATOR_ID];
    [_bannerView loadRequest:request];
}


- (void)adViewDidReceiveAd:(GADBannerView *)view {
    
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    
}

@end
