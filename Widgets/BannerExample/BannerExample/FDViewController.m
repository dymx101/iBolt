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

#define MY_BANNER_UNIT_ID @"a152f5fd1fc166f"

@interface FDViewController () {
    GADBannerView *bannerView_;
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
	
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[GAD_SIMULATOR_ID];
    [bannerView_ loadRequest:request];
}


@end
