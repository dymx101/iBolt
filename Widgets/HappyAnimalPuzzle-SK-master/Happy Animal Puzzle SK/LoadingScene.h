//
//  LoadingScene.h
//  Happy Animal Puzzle SK
//
//  Created by scnfex on 10/8/13.
//  Copyright (c) 2013 MopCat Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface LoadingScene : SKScene

- (void)setLoadingImage:(UIImage *)image;
- (void)setLoadingBlock:(void(^)(void))block;
- (void)setNextScene:(SKScene *)nextScene;

@end
