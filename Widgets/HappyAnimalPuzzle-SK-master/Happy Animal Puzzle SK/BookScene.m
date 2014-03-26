//
//  BookScene.m
//  Happy Animal Puzzle SK
//
//  Created by scnfex on 9/27/13.
//  Copyright (c) 2013 MopCat Games. All rights reserved.
//

#import "BookScene.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "MyIAPHelper.h"

@interface BookScene ()

@property (nonatomic) SKNode *menuLayer;

@end

@implementation BookScene

- (void)createContent {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"farm_book_open.png"];
    background.position = skp([self centerX], [self centerY]);
    [self addChild:background];
    
    SKSpriteNode *bg = nil;
    if (self.animalCategory == kAnimalCategoryFarm) {
        bg = [SKSpriteNode spriteNodeWithImageNamed:@"farm_book_open.png"];
    }
    else if (self.animalCategory == kAnimalCategoryGrass) {
        bg = [SKSpriteNode spriteNodeWithImageNamed:@"grass_book_open.png"];
    }
    else {
        bg = [SKSpriteNode spriteNodeWithImageNamed:@"ocean_book_open.png"];
    }
    bg.position = skp(self.size.width*0.5f, self.size.height*0.5f);
    [self addChild:bg];
    
    [self createMenu];
}

- (void)didMoveToView:(SKView *)view {
    [self createContent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeLock)
                                                 name:IAPHelperProductPurchasedNotification
                                               object:nil];
}

- (void)willMoveFromView:(SKView *)view {
    [self removeAllChildren];
    self.menuLayer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)removeLock {
    [self.menuLayer removeFromParent];
    self.menuLayer = nil;
    
    [self createMenu];
}

- (void)createMenu {
    if (!self.menuLayer) {
        self.menuLayer = [SKNode node];
        self.menuLayer.position = CGPointZero;
        [self addChild:self.menuLayer];
    }
    
    SKSpriteButtonNode *closeBtn = [SKSpriteButtonNode buttonNodeWithNormalTexture:[SKTexture textureWithImageNamed:@"close_btn.png"]
                                                         selectedTexture:nil
                                                                  block:^(id sender) {
                                                                      if ([Utility sharedUtility].isSoundAvaliable) {
                                                                          [self runAction:[SKAction playSoundFileNamed:kSoundEffectClick
                                                                                                     waitForCompletion:NO]];
                                                                      }
                                                                      
                                                                      SKTransition *transition = [SKTransition fadeWithDuration:0.8f];
                                                                      [self.view presentScene:self.menuScene
                                                                                   transition:transition];
                                                                  }];
    closeBtn.position = skp(937, 704);
    [self.menuLayer addChild:closeBtn];
    
    int numOfItem = 6;
    for (int i = 0; i != numOfItem; i++) {
        NSString *frame = [NSString stringWithFormat:@"BookMenu_%d_%d.png", self.animalCategory, i];
        
        BOOL isLock = [Utility isAppUpgrade] == NO && i >= (3-self.animalCategory);
        
        SKSpriteButtonNode *item = [SKSpriteButtonNode buttonNodeWithNormalTexture:[SKTexture textureWithImageNamed:frame]
                                                         selectedTexture:nil
                                                                  block:^(id sender) {
                                                                      if (isLock) {
                                                                          if ([Utility sharedUtility].isSoundAvaliable) {
                                                                              [self runAction:[SKAction playSoundFileNamed:kSoundEffectError
                                                                                                         waitForCompletion:NO]];
                                                                          }
                                                                          
                                                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade to full version"
                                                                                                                          message:@"Upgrade to full version to play all puzzles and remove ad banner forever!"
                                                                                                                         delegate:self
                                                                                                                cancelButtonTitle:@"No, Thanks"
                                                                                                                otherButtonTitles:@"OK", nil];
                                                                          [alert show];
                                                                      }
                                                                      else {
                                                                          if ([Utility sharedUtility].isSoundAvaliable) {
                                                                              [self runAction:[SKAction playSoundFileNamed:kSoundEffectClick
                                                                                                         waitForCompletion:NO]];
                                                                          }
                                                                          
                                                                          NSString *animalAtlasName = [NSString stringWithFormat:@"Animal_%d_%d.atlas",
                                                                                                       self.animalCategory, i];
                                                                          SKTextureAtlas *animalAtlas = [SKTextureAtlas atlasNamed:animalAtlasName];
                                                                          [SKTextureAtlas preloadTextureAtlases:@[animalAtlas]
                                                                                          withCompletionHandler:^{
                                                                                              SKTransition *transition = [SKTransition fadeWithDuration:0.8f];
                                                                                              
                                                                                              GameScene *gameScene = [GameScene sceneWithSize:self.size];
                                                                                              gameScene.animalCategory = self.animalCategory;
                                                                                              gameScene.animalIndex = i;
                                                                                              gameScene.bookScene = self;
                                                                                              
                                                                                              [self.view presentScene:gameScene
                                                                                                           transition:transition];
                                                                                          }];
                                                                      }
                                                                  }];
        item.position = skp(273 + i/3*490, 570 - i%3*(item.size.height + 15));
        [self.menuLayer addChild:item];
        
        if (isLock) {
            SKSpriteNode *grayLayer = [SKSpriteNode spriteNodeWithColor:skColor4(0, 0, 0, 255*0.7)
                                                                   size:item.size];
            grayLayer.position = CGPointZero;
            [item addChild:grayLayer];
            
            SKSpriteNode *lock = [SKSpriteNode spriteNodeWithImageNamed:@"lock.png"];
            lock.position = CGPointZero;
            [item addChild:lock];
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if ([MyIAPHelper sharedInstance].upgradeProduct) {
            [[MyIAPHelper sharedInstance] buyProduct:[MyIAPHelper sharedInstance].upgradeProduct];
        }
        else {
            [[MyIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
                if (products.count == 1) {
                    SKProduct *product = [products objectAtIndex:0];
                    [[MyIAPHelper sharedInstance] buyProduct:product];
                    [MyIAPHelper sharedInstance].upgradeProduct = product;
                }
            }];
        }
    }
}

@end
