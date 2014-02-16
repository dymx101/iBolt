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
#import "FDCustomURLCache.h"

@implementation FDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // observe notifications
    [self watchOut];
    
    // custom cache
    [NSURLCache setSharedURLCache:[FDCustomURLCache new]];
    
    // create window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // create drawer controller
    FDMenuVC *menuVC = [FDMenuVC new];
    FDBrowserVC *browserVC = [FDBrowserVC new];
    
    _drawerController = [[MMDrawerController alloc] initWithCenterViewController:[self naviWithVC:browserVC] leftDrawerViewController:menuVC];
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
         
     }];
}

-(UINavigationController *)naviWithVC:(UIViewController *)aController
{
    if (aController) {
        return [[UINavigationController alloc] initWithRootViewController:aController];
    }
    
    return nil;
}


#pragma mark - notifications
-(void)watchOut {
    [self observeNotification:DF_NOTIFY_CLOSE_DRAWER];
    [self observeNotification:DF_NOTIFY_OPEN_DRAWER];
    [self observeNotification:DF_NOTIFY_SET_CENTER_CONTROLLER];
}

-(void)handleNotification:(NSNotification *)notification {
    NSString *name = notification.name;
    if ([name isEqualToString:DF_NOTIFY_CLOSE_DRAWER]) {
        [_drawerController closeDrawerAnimated:YES completion:nil];
    } else if ([name isEqualToString:DF_NOTIFY_SET_CENTER_CONTROLLER]) {
        id object = notification.object;
        if ([object isKindOfClass:[UIViewController class]]) {
            [_drawerController setCenterViewController:[self naviWithVC:object] withCloseAnimation:YES completion:nil];
        }
    }
}

@end
