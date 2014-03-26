//
//  PuzzleBlock.h
//  Happy Animal Puzzle SK
//
//  Created by scnfex on 10/9/13.
//  Copyright (c) 2013 MopCat Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class GameScene;

@interface PuzzleBlock : SKSpriteNode

@property (nonatomic, assign) CGPoint targetPos;
@property (nonatomic, weak) GameScene *gameScene;

@end
