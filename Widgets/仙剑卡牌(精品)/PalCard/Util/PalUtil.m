//
//  PalUtil.m
//  PalCard
//
//  Created by Dong Yiming on 2/11/14.
//  Copyright (c) 2014 FlyinGeek. All rights reserved.
//

#import "PalUtil.h"
#import "UIImage+animatedGIF.h"

@implementation PalUtil

+(NSString *)mainBgMusicFile {
    return [[NSBundle mainBundle] pathForResource:@"main_bg.mp3" ofType:nil];
    //[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"main0%d.mp3", arc4random() % 2 + 1];
}

+(NSString *)freeOriginalImagePath:(NSUInteger)aNumber {
    return [NSString stringWithFormat:@"1Free/original/%d.png", aNumber];
}

+(NSString *)freePremiumImagePath:(NSUInteger)aNumber {
    return [NSString stringWithFormat:@"1Free/premium/%dp.gif", aNumber];
}

+(UIImage *)imageFromPath:(NSString *)aImagePath {
    
    if (aImagePath.length <= 0) {
        return nil;
    }
    
    if ([aImagePath.lowercaseString rangeOfString:@"gif"].location != NSNotFound) {
        //gif
        NSURL *url = [[NSBundle mainBundle] URLForResource:aImagePath withExtension:nil];
        return [UIImage animatedImageWithAnimatedGIFURL:url];
    } else {
        return [UIImage imageNamed:aImagePath];
    }
    
    return nil;
}

@end
