//
//  GameScene.h
//  Happy Animal Puzzle SK
//
//  Created by scnfex on 9/27/13.
//  Copyright (c) 2013 MopCat Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

enum {
    kBackgroundLayerZ = 0,
    kPuzzleLayerZ = 100,
    kMenuLayerZ = 200,
    kLoadingLayerZ = 300
};

#define kPuzzleBlockName @"block"

@class BookScene;

@interface GameScene : SKScene

@property (nonatomic) int animalIndex;
@property (nonatomic) int animalCategory;
@property (nonatomic) int finishBlockNumber;
@property (nonatomic) BookScene *bookScene;

@end
