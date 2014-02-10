//
//  FDViewController.m
//  BannerExample
//
//  Created by Dong Yiming on 2/9/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

// see: https://developers.google.com/mobile-ads-sdk/docs/admob/intermediate#ios

#import "FDViewController.h"
#import "GADBannerView.h"
#import <iAd/iAd.h>

#define MY_BANNER_UNIT_ID @"a152f5fd1fc166f"

@interface FDViewController () <ADBannerViewDelegate> {
    GADBannerView *bannerView_;
    ADBannerView *bannerView;
}

@end

@implementation FDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
#if 0
    //admob
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[GAD_SIMULATOR_ID];
    [bannerView_ loadRequest:request];
    
#else
    //iad
    bannerView = [[ADBannerView alloc]initWithFrame:
                  CGRectMake(0, 0, 320, 50)];
    // Optional to set background color to clear color
    [bannerView setBackgroundColor:[UIColor clearColor]];
    bannerView.delegate = self;
    [self.view addSubview: bannerView];
    
#endif
}


#pragma mark - AdViewDelegates

-(void)bannerView:(ADBannerView *)banner
didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Error loading:%@", error);
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad loaded");
}
-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad will load");
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"Ad did finish");
    
}

@end
