//
//  Utility.m
//  Happy Animal Puzzle
//
//  Created by Bobo Shone on 13-6-23.
//  Copyright (c) 2013年 MopCatGame. All rights reserved.
//

#import "Utility.h"
#import "MyIAPHelper.h"

@implementation Utility

+ (Utility *)sharedUtility {
    static Utility *utilitySingleton = nil;
    if (!utilitySingleton) {
        utilitySingleton = [[Utility alloc] init];
    }
    return utilitySingleton;
}

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

+ (NSArray *)blockPositionForLevelType:(LevelType)level {
    if (level == kLevelType2x2) {
        return [NSArray arrayWithObjects:
                [NSValue valueWithCGPoint:CGPointMake(404, 412)],
                [NSValue valueWithCGPoint:CGPointMake(598, 425)],
                [NSValue valueWithCGPoint:CGPointMake(418, 218)],
                [NSValue valueWithCGPoint:CGPointMake(612, 232)],
                nil];
    }
    else if (level == kLevelType3x2) {
        return [NSArray arrayWithObjects:
                [NSValue valueWithCGPoint:CGPointMake(374, 426)],
                [NSValue valueWithCGPoint:CGPointMake(508, 412)],
                [NSValue valueWithCGPoint:CGPointMake(642, 426)],
                [NSValue valueWithCGPoint:CGPointMake(365, 231)],
                [NSValue valueWithCGPoint:CGPointMake(508, 218)],
                [NSValue valueWithCGPoint:CGPointMake(651, 231)],
                nil];
    }
    else {
        return [NSArray arrayWithObjects:
                [NSValue valueWithCGPoint:CGPointMake(373, 465)],
                [NSValue valueWithCGPoint:CGPointMake(507, 456)],
                [NSValue valueWithCGPoint:CGPointMake(642, 465)],
                [NSValue valueWithCGPoint:CGPointMake(365, 322)],
                [NSValue valueWithCGPoint:CGPointMake(508, 322)],
                [NSValue valueWithCGPoint:CGPointMake(651, 322)],
                [NSValue valueWithCGPoint:CGPointMake(374, 179)],
                [NSValue valueWithCGPoint:CGPointMake(508, 188)],
                [NSValue valueWithCGPoint:CGPointMake(642, 179)],
                nil];
    }
    
    return nil;
}

+ (BOOL)isAppUpgrade {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUpgradeIAPIdentifier];
}

@end
