//
//  MyIAPHelper.m
//  Happy Animal Puzzle
//
//  Created by scnfex on 6/24/13.
//  Copyright (c) 2013 MopCatGame. All rights reserved.
//

#import "MyIAPHelper.h"

@implementation MyIAPHelper

+ (MyIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static MyIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                        kUpgradeIAPIdentifier,
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
