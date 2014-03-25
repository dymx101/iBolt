//
//  PalAppDelegate.h
//  PalCard
//
//  Created by FlyinGeek on 13-1-28.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface PalAppDelegate : UIResponder <UIApplicationDelegate, GADBannerViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) GADBannerView *bannerView;

@end


#define SharedDelegate ((PalAppDelegate *)([UIApplication sharedApplication].delegate))
