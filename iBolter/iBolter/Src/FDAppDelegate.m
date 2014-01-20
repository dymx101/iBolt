//
//  FDAppDelegate.m
//  iBolter
//
//  Created by Dong Yiming on 1/20/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "FDAppDelegate.h"

// view controllers
#import "FDMenuVC.h"
#import "FDBrowserVC.h"

// drawer
#import "MMDrawerVisualStateManager.h"


@implementation FDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // create window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // create drawer controller
    FDMenuVC *menuVC = [FDMenuVC new];
    FDBrowserVC *browserVC = [FDBrowserVC new];
    UIViewController *centerVC = [[UINavigationController alloc] initWithRootViewController:browserVC];
    _drawerController = [[MMDrawerController alloc] initWithCenterViewController:centerVC leftDrawerViewController:menuVC];
    self.window.rootViewController = _drawerController;
    [self setupDrawerController];
    
    // make window visible
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

#pragma mark - extra methods
-(void)setupDrawerController {
    [_drawerController setRestorationIdentifier:@"MMDrawer"];
    [_drawerController setMaximumRightDrawerWidth:100.0];
    _drawerController.maximumLeftDrawerWidth = 150;
    _drawerController.showsShadow = YES;
    [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    // set up visual state block
    [_drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         MMDrawerVisualStateManager *sharedVisualManager = [MMDrawerVisualStateManager sharedManager];
         sharedVisualManager.leftDrawerAnimationType = MMDrawerAnimationTypeSwingingDoor;
         sharedVisualManager.rightDrawerAnimationType = MMDrawerAnimationTypeParallax;
         
         block = [sharedVisualManager drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
         
         //
         UIViewController * sideDrawerViewController;
         
         if(drawerSide == MMDrawerSideRight){
             sideDrawerViewController = drawerController.rightDrawerViewController;
         }
         [sideDrawerViewController.view setAlpha:percentVisible];
         
     }];
}

@end
