//
//  Utility.h
//  Happy Animal Puzzle
//
//  Created by Bobo Shone on 13-6-23.
//  Copyright (c) 2013年 MopCatGame. All rights reserved.
//

#import <Foundation/Foundation.h>

#define randomBetween(x,y) (x + arc4random() % (int)(y-x))

typedef enum {
    kAnimalCategoryFarm = 0,
    kAnimalCategoryGrass,
    kAnimalCategoryOcean
} AnimalCategory;

typedef enum {
    kLevelType2x2 = 0,
    kLevelType3x2,
    kLevelType3x3,
} LevelType;

#pragma mark - Sound file name

#define kBackgroundMusic @"bg.mp3"
#define kSoundEffectFinishGame @""
#define kSoundEffectClick @"click.mp3"
#define kSoundEffectFinish @"finish.wav"
#define kSoundEffectBlock @"block.mp3"
#define kSoundEffectError @"ao.mp3"

#pragma mark -

@interface Utility : NSObject

+ (Utility *)sharedUtility;
+ (NSArray *)blockPositionForLevelType:(LevelType)level;
+ (BOOL)isAppUpgrade;

@property (nonatomic, assign) BOOL isSoundAvaliable;

@end
