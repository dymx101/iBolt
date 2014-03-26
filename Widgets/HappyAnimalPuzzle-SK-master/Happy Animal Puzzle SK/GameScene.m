//
//  GameScene.m
//  Happy Animal Puzzle SK
//
//  Created by scnfex on 9/27/13.
//  Copyright (c) 2013 MopCat Games. All rights reserved.
//

#import "GameScene.h"

#import "MenuScene.h"
#import "PuzzleBlock.h"
#import "BookScene.h"
#import "LoadingScene.h"
#import "MyIAPHelper.h"

#define kFadeDuration 1.0f
#define kParticleTag 100

#define kTitleName @"title"
#define kParticleName @"particle"

@interface GameScene ()

@property (nonatomic) SKSpriteNode *puzzlePicture;

@property (nonatomic) SKSpriteButtonNode *level1Btn;
@property (nonatomic) SKSpriteButtonNode *level2Btn;
@property (nonatomic) SKSpriteButtonNode *level3Btn;
@property (nonatomic) SKSpriteButtonNode *nextBtn;
@property (nonatomic) LevelType currnetLevel;

@property (nonatomic) SKSpriteNode *woodBlock;
@property (nonatomic) BOOL isGameFinish;
@property (nonatomic) int blockNum;
@property (nonatomic) BOOL isGameStart;
@property (nonatomic) BOOL selectLevel;

@end

@implementation GameScene

- (void)createContent {
    
    [self initBackground];
    
    [self initButtons];
}

- (void)initButtons {
    SKSpriteButtonNode *closeBtn = [SKSpriteButtonNode buttonNodeWithNormalTexture:[SKTexture textureWithImageNamed:@"back_btn.png"]
                                                                   selectedTexture:nil
                                                                             block:^(id sender) {
                                                                                 if ([Utility sharedUtility].isSoundAvaliable) {
                                                                                     [self runAction:[SKAction playSoundFileNamed:kSoundEffectClick
                                                                                                                waitForCompletion:NO]];
                                                                                 }
                                                                                 
                                                                                 SKTransition *transition = [SKTransition fadeWithDuration:0.8f];
                                                                                 [self.view presentScene:self.bookScene
                                                                                              transition:transition];
                                                                             }];
    closeBtn.position = skp(50, 50);
    
    SKSpriteButtonNode *homeBtn = [SKSpriteButtonNode buttonNodeWithNormalTexture:[SKTexture textureWithImageNamed:@"home_btn.png"]
                                                                  selectedTexture:nil
                                                                            block:^(id sender) {
                                                                                if ([Utility sharedUtility].isSoundAvaliable) {
                                                                                    [self runAction:[SKAction playSoundFileNamed:kSoundEffectClick
                                                                                                               waitForCompletion:NO]];
                                                                                }
                                                                                
                                                                                SKTransition *transition = [SKTransition fadeWithDuration:0.8f];
                                                                                [self.view presentScene:self.bookScene.menuScene
                                                                                             transition:transition];
                                                                            }];
    homeBtn.position = skp(50, 150);
    
    
    self.level1Btn = [SKSpriteButtonNode buttonNodeWithNormalTexture:[SKTexture textureWithImageNamed:@"level1_btn.png"]
                                                     selectedTexture:nil
                                                               block:^(id sender) {
                                                                   if ([Utility sharedUtility].isSoundAvaliable) {
                                                                       [self runAction:[SKAction playSoundFileNamed:kSoundEffectClick
                                                                                                  waitForCompletion:NO]];
                                                                   }
                                                                   
                                                                   [self playLevel:kLevelType2x2];
                                                               }];
    self.level1Btn.position = skp(900, 350);
    self.level1Btn.scale = 0;
    
    self.level2Btn = [SKSpriteButtonNode buttonNodeWithNormalTexture:[SKTexture textureWithImageNamed:@"level2_btn.png"]
                                                     selectedTexture:nil
                                                               block:^(id sender) {
                                                                   if ([Utility sharedUtility].isSoundAvaliable) {
                                                                       [self runAction:[SKAction playSoundFileNamed:kSoundEffectClick
                                                                                                  waitForCompletion:NO]];
                                                                   }
                                                                   
                                                                   [self playLevel:kLevelType3x2];
                                                               }];
    self.level2Btn.position = skp(900, 250);
    self.level2Btn.scale = 0;
    
    self.level3Btn = [SKSpriteButtonNode buttonNodeWithNormalTexture:[SKTexture textureWithImageNamed:@"level3_btn.png"]
                                                     selectedTexture:nil
                                                               block:^(id sender) {
                                                                   if ([Utility sharedUtility].isSoundAvaliable) {
                                                                       [self runAction:[SKAction playSoundFileNamed:kSoundEffectClick
                                                                                                  waitForCompletion:NO]];
                                                                   }
                                                                   
                                                                   [self playLevel:kLevelType3x3];
                                                               }];
    self.level3Btn.position = skp(900, 150);
    self.level3Btn.scale = 0;
    
    self.nextBtn = [SKSpriteButtonNode buttonNodeWithNormalTexture:[SKTexture textureWithImageNamed:@"next_btn.png"]
                                                   selectedTexture:nil
                                                             block:^(id sender) {
                                                                 if ([Utility sharedUtility].isSoundAvaliable) {
                                                                     [self runAction:[SKAction playSoundFileNamed:kSoundEffectClick
                                                                                                waitForCompletion:NO]];
                                                                 }
                                                                 
                                                                 
                                                                 if (!self.nextBtn.paused) {
                                                                     [self.nextBtn removeAllActions];
                                                                     self.nextBtn.scale = 1.0f;
                                                                 }
                                                                 
                                                                 [self playNextAnimal];
                                                             }];
    self.nextBtn.position = skp(self.size.width-50, 50);
    self.nextBtn.alpha = 0;
    
    //    CGFloat z = kMenuLayerZ;
    closeBtn.zPosition = kMenuLayerZ;
    homeBtn.zPosition = kMenuLayerZ;
    self.level1Btn.zPosition = kMenuLayerZ;
    self.level2Btn.zPosition = kMenuLayerZ;
    self.level3Btn.zPosition = kMenuLayerZ;
    self.nextBtn.zPosition = kMenuLayerZ;
    
    [self addChild:closeBtn];
    [self addChild:homeBtn];
    [self addChild:self.level1Btn];
    [self addChild:self.level2Btn];
    [self addChild:self.level3Btn];
    [self addChild:self.nextBtn];
    
    // animations
    SKAction *animation = [SKAction sequence:@[[SKAction scaleTo:1.3f duration:0.2f],
                                               [SKAction scaleTo:0.8f duration:0.2f],
                                               [SKAction scaleTo:1.1f duration:0.2f],
                                               [SKAction scaleTo:1.0f duration:0.2f]]];
    
    [self.level1Btn runAction:animation];
    [self.level2Btn runAction:[SKAction sequence:@[[SKAction waitForDuration:0.3f],
                                                   animation]]];
    [self.level3Btn runAction:[SKAction sequence:@[[SKAction waitForDuration:0.6f],
                                                   animation]]];
    
    self.selectLevel = YES;
}

- (void)dealloc {
    
}

- (void)didMoveToView:(SKView *)view {
    [self createContent];
}

- (void)willMoveFromView:(SKView *)view {
    [self removeAllChildren];
}

- (void)initBackground {
    SKColor *color;
    NSString *patternFile;
    
    if (self.animalCategory == kAnimalCategoryFarm) {
        color = skColor3(254, 217, 123);
        patternFile = @"bg_pattern_1.png";
    }
    else if (self.animalCategory == kAnimalCategoryGrass) {
        color = skColor3(185, 230, 90);
        patternFile = @"bg_pattern_2.png";
    }
    else if (self.animalCategory == kAnimalCategoryOcean) {
        color = skColor3(98, 208, 255);
        patternFile = @"bg_pattern_3.png";
    }
    
    CGFloat z = kBackgroundLayerZ;
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:color
                                                            size:self.size];
    background.position = skp(self.centerX, self.centerY);
    [self addChild:background];
    background.zPosition = z++;
    
    SKSpriteNode *pattern = [SKSpriteNode spriteNodeWithImageNamed:patternFile];
    pattern.position = skp(self.centerX, self.centerY);
    [self addChild:pattern];
    pattern.zPosition = z++;
    
    self.woodBlock = [SKSpriteNode spriteNodeWithImageNamed:@"puzzle_bg.png"];
    self.woodBlock.position = skp(self.centerX, 319);
    self.woodBlock.zPosition = 0;
    [self addChild:self.woodBlock];
    self.woodBlock.zPosition = z++;
    
    NSString *file = [NSString stringWithFormat:@"animal_%d_%d.png", self.animalCategory, self.animalIndex];
    self.puzzlePicture = [SKSpriteNode spriteNodeWithImageNamed:file];
    self.puzzlePicture.position = skp(self.centerX-2, 320);
    [self addChild:self.puzzlePicture];
    self.puzzlePicture.zPosition = z++;
}

- (void)moveBlocks {
    [self enumerateChildNodesWithName:kPuzzleBlockName
                           usingBlock:^(SKNode *node, BOOL *stop) {
                               SKSpriteNode *block = (SKSpriteNode *)node;
                               
                               float width = block.size.width;
                               float height = block.size.height;
                               
                               float randomX = randomBetween(width*0.5, self.size.width-width*0.5);
                               float randomY = randomBetween(height*0.5, self.size.height - height*0.5);
                               
                               SKAction *move = [SKAction moveTo:skp(randomX, randomY) duration:0.5f];
                               [block runAction:move completion:^{
                                   block.userInteractionEnabled = YES;
                               }];
                           }];
}

- (void)startParticle {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Spark" ofType:@"sks"];
    
    SKEmitterNode *particle = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    particle.particlePosition = self.puzzlePicture.position;
    particle.particlePositionRange = CGVectorMake(self.puzzlePicture.size.width,
                                                  self.puzzlePicture.size.height);

    [self addChild:particle];
    particle.zPosition = kLoadingLayerZ;
    particle.name = kParticleName;
}

- (void)addAnimalTitle {
    NSArray *titles = [NSArray arrayWithObjects:
                       @"SHEEP",
                       @"PIG",
                       @"HORSE",
                       @"COW",
                       @"DOG",
                       @"CAT",
                       @"GIRAFFE",
                       @"ZEBRA",
                       @"LION",
                       @"ELEPHANT",
                       @"HIPPO",
                       @"MONKEY",
                       @"SEA LION",
                       @"CETACEAN",
                       @"PENGUIN",
                       @"POLAR BEAR",
                       @"REINDEER",
                       @"TIGER WHALE",
                       nil];
    int index = self.animalCategory * 6 + self.animalIndex;
    NSString *title = [titles objectAtIndex:index];
    
    float totalWidth = 0.0f;
    float f = 5.0f;
    NSMutableArray *characters = [NSMutableArray arrayWithCapacity:title.length];
    
    for (int i = 0; i != title.length; i++) {
        NSString *c = [title substringWithRange:NSMakeRange(i, 1)];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Shark Soft Bites"];
        label.fontSize = 100;
        label.text = c;
        label.position = skp(self.centerX, self.size.height - 150);
        [self addChild:label];
        label.zPosition = kMenuLayerZ;
        label.name = kTitleName;
        
        if (self.animalCategory == kAnimalCategoryFarm) {
            label.fontColor = skColor3(255, 156, 0);
        }
        else if (self.animalCategory == kAnimalCategoryGrass) {
            label.fontColor = skColor3(99, 192, 0);
        }
        else {
            label.fontColor = skColor3(0, 168, 255);
        }
        
        float width = label.frame.size.width;
        totalWidth += width + f*2;
        [characters addObject:label];
    }
    
    float temp = 0.0f;
    for (int i = 0; i != title.length; i++) {
        SKLabelNode *label = [characters objectAtIndex:i];
        
        float width = label.frame.size.width;
        
        label.position = skp(self.size.width*0.5 - totalWidth*0.5 + temp, self.size.height - 150);
        temp += width + f*2;
        
        label.scale = 0.01;
        
        id a1 = [SKAction scaleTo:1.3f duration:0.2f];
        id a2 = [SKAction scaleTo:0.8f duration:0.2f];
        id a3 = [SKAction scaleTo:1.1f duration:0.2f];
        id a4 = [SKAction scaleTo:1.0f duration:0.2f];
        id a5 = [SKAction waitForDuration:i*0.2f];
        id a6 = [SKAction sequence:@[a5, a1,a2,a3,a4]];
        [label runAction:a6];
    }
}

- (void)gameFinish {
    if (!self.isGameFinish && self.isGameStart) {
        self.isGameFinish = YES;
        self.isGameStart = NO;
        
        if ([Utility sharedUtility].isSoundAvaliable) {
            [self runAction:[SKAction playSoundFileNamed:kSoundEffectFinish
                                       waitForCompletion:NO]];
        }
        
        self.puzzlePicture.alpha = 1.0f;
        
        [self enumerateChildNodesWithName:kPuzzleBlockName
                               usingBlock:^(SKNode *node, BOOL *stop) {
                                   SKSpriteNode *block = (SKSpriteNode *)node;
                                   [block runAction:[SKAction fadeOutWithDuration:kFadeDuration]];
                               }];
        
        [self startParticle];
        [self addAnimalTitle];
        
        [self.nextBtn runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction scaleTo:1.5f duration:0.3f],
                                                                                   [SKAction scaleTo:1.0f duration:0.3f]]]]];
    }
}

- (void)update:(NSTimeInterval)currentTime {
    if (self.finishBlockNumber == self.blockNum) {
        [self gameFinish];
    }
}

- (void)playLevel:(LevelType)level {
    self.isGameFinish = NO;
    
    self.currnetLevel = level;
    
    self.blockNum = 0;
    NSString *preName = nil;
    if (level == kLevelType2x2) {
        self.blockNum = 4;
        preName = @"2x2";
    }
    else if (level == kLevelType3x2) {
        self.blockNum = 6;
        preName = @"3x2";
    }
    else {
        self.blockNum = 9;
        preName = @"3x3";
    }
    
    for (int i = 0; i != self.blockNum; i++) {
        NSString *frameName = [NSString stringWithFormat:@"animal_%d_%d_%@_%d.png",
                               self.animalCategory, self.animalIndex, preName, i];
        PuzzleBlock *block = [PuzzleBlock spriteNodeWithImageNamed:frameName];
        block.position = [[[Utility blockPositionForLevelType:level] objectAtIndex:i] CGPointValue];
        block.targetPos = block.position;
        [self addChild:block];
        block.zPosition = kPuzzleLayerZ;
        block.name = kPuzzleBlockName;
        
        
        block.gameScene = self;
        
        block.alpha = 0;
        
        [block runAction:[SKAction fadeInWithDuration:kFadeDuration]];
    }
    
    [self.puzzlePicture runAction:[SKAction sequence:@[[SKAction waitForDuration:kFadeDuration],
                                                       [SKAction runBlock:^{
        self.puzzlePicture.alpha = 0;
    }]]]];
    
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kFadeDuration],
                                         [SKAction performSelector:@selector(moveBlocks)
                                                          onTarget:self]]]];
    
    self.finishBlockNumber = 0;
    
    if (self.selectLevel) {
        self.selectLevel = NO;
        
        [self.level1Btn runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:kFadeDuration],
                                                       [SKAction removeFromParent]]]];
        [self.level2Btn runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:kFadeDuration],
                                                       [SKAction removeFromParent]]]];
        [self.level3Btn runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:kFadeDuration],
                                                       [SKAction removeFromParent]]]];
        
        self.nextBtn.alpha = 0.0f;
        [self.nextBtn runAction:[SKAction fadeInWithDuration:kFadeDuration]];
    }
    else {
        self.nextBtn.alpha = 1.0f;
    }
    
    self.isGameStart = YES;
}

- (void)playNextAnimal {
    BOOL isAppUpgrade = [Utility isAppUpgrade];
    
    int nextAnimalIndex = self.animalIndex;
    int nextAnimalCategory = self.animalCategory;
    if (self.animalIndex < 5) {
        nextAnimalIndex++;
    }
    else if (self.animalIndex == 5) {
        if (self.animalCategory < 2) {
            nextAnimalCategory++;
        }
        else if (self.animalCategory == 2) {
            nextAnimalCategory = 0;
            nextAnimalIndex = 0;
        }
    }
    
    BOOL isLock = !isAppUpgrade && nextAnimalIndex >= (3-nextAnimalCategory);
    if (isLock) {
        if ([Utility sharedUtility].isSoundAvaliable) {
            [self runAction:[SKAction playSoundFileNamed:kSoundEffectError waitForCompletion:NO]];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade to full version"
                                                        message:@"Upgrade to full version to play all puzzles and remove ad banner forever!"
                                                       delegate:self
                                              cancelButtonTitle:@"No, Thanks"
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    SKNode *loadingLayer = [SKNode node];
    loadingLayer.position = skp(self.centerX, self.centerY);
    [self addChild:loadingLayer];
    loadingLayer.zPosition = kLoadingLayerZ;
    
    SKColor *color1;
    SKColor *color2;
    if (self.animalCategory == kAnimalCategoryFarm) {
        color1 = skColor3(255, 177, 0);
        color2 = skColor3(255, 205, 92);
    }
    else if (self.animalCategory == kAnimalCategoryGrass) {
        color1 = skColor3(85, 189, 0);
        color2 = skColor3(136, 214, 0);
    }
    else if (self.animalCategory == kAnimalCategoryOcean) {
        color1 = skColor3(0, 168, 255);
        color2 = skColor3(29, 194, 255);
    }
    
    for (int i = 0; i != 16; i++) {
        
        SKSpriteNode *topPattern = [SKSpriteNode spriteNodeWithImageNamed:@"top_pattern.png"];
        
        float width = topPattern.size.width;
        
        topPattern.position = skp((i+0.5)*width - 20, self.size.height*0.5);
        [loadingLayer addChild:topPattern];
        
        topPattern.colorBlendFactor = 1.0f;
        if (i % 2 == 0) {
            topPattern.color = color1;
        }
        else {
            topPattern.color = color2;
        }
    }
    
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"logo.png"];
    logo.position = skp(self.size.width*0.5, self.size.height*0.5);
    [loadingLayer addChild:logo];
    
    SKSpriteNode *eye1 = [SKSpriteNode spriteNodeWithImageNamed:@"eye_0.png"];
    eye1.position = skp(73 - logo.size.width*0.5, 122 - logo.size.height*0.5);
    [logo addChild:eye1];
    
    SKSpriteNode *eye2 = [SKSpriteNode spriteNodeWithImageNamed:@"eye_0.png"];
    eye2.position = skp(100 - logo.size.width*0.5, 127 - logo.size.height*0.5);
    [logo addChild:eye2];
    
    SKSpriteNode *eye3 = [SKSpriteNode spriteNodeWithImageNamed:@"eye_0.png"];
    eye3.position = skp(312 - logo.size.width*0.5, 125 - logo.size.height*0.5);
    [logo addChild:eye3];
    
    SKSpriteNode *eye4 = [SKSpriteNode spriteNodeWithImageNamed:@"eye_0.png"];
    eye4.position = skp(342 - logo.size.width*0.5, 127 - logo.size.height*0.5);
    [logo addChild:eye4];
    
    loadingLayer.position = skp(0,self.size.height + 65);
    
    [loadingLayer runAction:[SKAction sequence:@[
                                                 [SKAction moveTo:CGPointZero duration:kFadeDuration],
                                                 [SKAction runBlock:^{
        self.animalIndex = nextAnimalIndex;
        self.animalCategory = nextAnimalCategory;
        
        NSString *animalAtlasName = [NSString stringWithFormat:@"Animal_%d_%d.atlas",
                                     self.animalCategory, self.animalIndex];
        SKTextureAtlas *animalAtlas = [SKTextureAtlas atlasNamed:animalAtlasName];
        
        [SKTextureAtlas preloadTextureAtlases:@[animalAtlas]
                        withCompletionHandler:^{
                            
                        }];
        
        [[self childNodeWithName:kParticleName] removeFromParent];
        
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"animal_%d_%d.png", self.animalCategory, self.animalIndex]];
        [self.puzzlePicture setTexture:texture];
        self.puzzlePicture.alpha = 1.0f;
        
        [self enumerateChildNodesWithName:kPuzzleBlockName
                               usingBlock:^(SKNode *node, BOOL *stop) {
                                   [node removeFromParent];
                               }];
        
        [self enumerateChildNodesWithName:kTitleName usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
    }],
                                                 [SKAction waitForDuration:kFadeDuration],
                                                 [SKAction moveTo:skp(0, self.size.height+65) duration:kFadeDuration],
                                                 [SKAction runBlock:^{
        [self playLevel:self.currnetLevel];
    }]
                                                 ]
                             ] completion:^{
        [loadingLayer removeFromParent];
    }];
    
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
