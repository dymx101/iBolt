//
//  PuzzleBlock.m
//  Happy Animal Puzzle SK
//
//  Created by scnfex on 10/9/13.
//  Copyright (c) 2013 MopCat Games. All rights reserved.
//

#import "PuzzleBlock.h"
#import "GameScene.h"

@implementation PuzzleBlock

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touches.count > 1) {
        return;
    }
    
    __block int maxZ = self.zPosition;
    [self.gameScene enumerateChildNodesWithName:kPuzzleBlockName
                                     usingBlock:^(SKNode *node, BOOL *stop) {
                                         if (node != self && node.zPosition > maxZ) {
                                             maxZ = node.zPosition;
                                         }
                                     }];
    self.zPosition = maxZ+1;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInNode:self.gameScene];
    
    if (skpDistance(touchPoint, self.targetPos) < 30) {
        SKAction *a1 = [SKAction moveTo:self.targetPos duration:0.2f];
        SKAction *a2 = [SKAction runBlock:^{
            if ([Utility sharedUtility].isSoundAvaliable) {
                [self runAction:[SKAction playSoundFileNamed:kSoundEffectBlock
                                           waitForCompletion:NO]];
            }
        }];
        SKAction *a3 = [SKAction sequence:@[a1,a2]];
        [self runAction:a3];
        
        self.userInteractionEnabled = NO;
        
        self.zPosition = kPuzzleLayerZ-1;
        
        self.gameScene.finishBlockNumber++;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touches.count > 1) {
        return;
    }
    
    CGPoint touchPoint = [[touches anyObject] locationInNode:self.gameScene];
    self.position = touchPoint;
}

@end
