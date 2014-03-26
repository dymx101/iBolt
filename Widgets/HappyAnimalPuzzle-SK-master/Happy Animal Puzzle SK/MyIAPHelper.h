//
//  MyIAPHelper.h
//  Happy Animal Puzzle
//
//  Created by scnfex on 6/24/13.
//  Copyright (c) 2013 MopCatGame. All rights reserved.
//

#import "IAPHelper.h"

#define kUpgradeIAPIdentifier @"HappyAnimalPuzzle.upgrade"

@interface MyIAPHelper : IAPHelper

+ (MyIAPHelper *)sharedInstance;

@property (nonatomic, strong) SKProduct *upgradeProduct;

@end
