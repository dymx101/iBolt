//
//  LoadingScene.m
//  Happy Animal Puzzle SK
//
//  Created by scnfex on 10/8/13.
//  Copyright (c) 2013 MopCat Games. All rights reserved.
//

#import "LoadingScene.h"

@interface LoadingScene () {
    void (^block_)(void);
    SKScene *nextScene_;
    UIImage *loadingImage_;
}

@end

@implementation LoadingScene

- (void)setLoadingImage:(UIImage *)image {
    if (loadingImage_ != image) {
        loadingImage_ = image;
    }
}

- (void)didMoveToView:(SKView *)view {
    SKTexture *texture = [SKTexture textureWithImage:loadingImage_];
    SKSpriteNode *loading = [SKSpriteNode spriteNodeWithTexture:texture];
    loading.position = skp(self.centerX, self.centerY);
    [self addChild:loading];
    
    block_();
    
    [self runAction:[SKAction waitForDuration:1.0f]
         completion:^{
             SKTransition *transition = [SKTransition pushWithDirection:SKTransitionDirectionUp duration:0.8f];
             [self.view presentScene:nextScene_ transition:transition];
         }];
}

- (void)setLoadingBlock:(void(^)(void))block
{
    block_ = [block copy];
}

- (void)setNextScene:(SKScene *)nextScene {
    nextScene_ = nextScene;
}

@end
