//
//  PalAppDelegate.m
//  PalCard
//
//  Created by FlyinGeek on 13-1-28.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalAppDelegate.h"
#import "PalDataInit.h"

@implementation PalAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [PalDataInit gameDataInit];
    
    [PalUtil appStoreVersionCheck];
    
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

@end
