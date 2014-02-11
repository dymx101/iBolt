//
//  PalUtil.m
//  PalCard
//
//  Created by Dong Yiming on 2/11/14.
//  Copyright (c) 2014 FlyinGeek. All rights reserved.
//

#import "PalUtil.h"

@implementation PalUtil

+(NSString *)mainBgMusicFile {
    return [[NSBundle mainBundle] pathForResource:@"main_bg.mp3" ofType:nil];
    //[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"main0%d.mp3", arc4random() % 2 + 1];
}

@end
