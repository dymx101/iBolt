//
//  BookScene.h
//  Happy Animal Puzzle SK
//
//  Created by scnfex on 9/27/13.
//  Copyright (c) 2013 MopCat Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MenuScene;

@interface BookScene : SKScene

@property (nonatomic) AnimalCategory animalCategory;
@property (nonatomic) MenuScene *menuScene;

@end
