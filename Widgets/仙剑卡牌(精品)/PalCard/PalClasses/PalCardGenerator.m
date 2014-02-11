//
//  PalCardGenerator.m
//  PalCard
//
//  Created by FlyinGeek on 13-1-31.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalCardGenerator.h"

#define TOTAL_CARD_COUNT    (64)
#define CARD_START_NUMBER   (301)

@interface PalCardGenerator () {
    bool _initialized;
    bool _lastIsBlack;
    NSInteger cards[7];
    NSInteger used[7];
    
    int blackRandomNumber1;
    int blackRandomNumber2;
}

@end


@implementation PalCardGenerator

-(u_int32_t)_randomCardNumber {
    return (random() % 2 ? random() : arc4random()) % TOTAL_CARD_COUNT + CARD_START_NUMBER;
}

- (void)prepare
{
    int cardNumber;
    
    bool _same = NO;
    int i = 1;
    
    cardNumber = [self _randomCardNumber];
    cards[1] = cardNumber;
    
    while (i <= 6) {
        
        _same = NO;
        
        cardNumber = [self _randomCardNumber];
        
        for (int j = 1; j <= i ; j++)
        {
            if (cardNumber == cards[j])
            {
                _same = YES;
                break;
            }
        }
        if (!_same)  {
            cards[++i] = cardNumber;
        }
    }
    
    blackRandomNumber1 = arc4random() % 6 + 1;          // 1~6
    blackRandomNumber2 = ( blackRandomNumber1 + 3 ) % 6 + 1;    // 1~6, but differ from blackRandomNumber1
    
  //  for (int i = 1; i <= 6; i++)
  //      NSLog(@"%d\n", cards[i]);

}

- (NSString *) lastIsBlack
{
    return _lastIsBlack ? @"YES" : @"NO";
}

- (NSString *)getACardWithPath
{
    if (!_initialized) {
        [self prepare];
        _initialized = YES;
    }
    
    int cardNumber;
    
    if (arc4random() % 2 == 0) {
        cardNumber = (random() + blackRandomNumber1) % 6 + 1;
    }
    else {
        cardNumber = (arc4random() +blackRandomNumber2) % 6 + 1;
    }
    
    
    while (used[cardNumber] == 2) {
        if (arc4random() % 2 == 0) {
            cardNumber = (arc4random() +blackRandomNumber1) % 6 + 1;
        }
        else {
            cardNumber = (random() +blackRandomNumber2) % 6 + 1;
        }
    }
    
    used[cardNumber] ++;
    
    NSString *path;
    
    if(self.NumbersOfBlackCards == 2) {
        if (cardNumber == blackRandomNumber1 || cardNumber == blackRandomNumber2) {
            path = [NSString stringWithFormat:@"palsource_black/%d.png", cards[cardNumber]];
            _lastIsBlack = YES;
            return path;
        }
    }
    
    if(self.NumbersOfBlackCards == 1) {
        if (cardNumber == blackRandomNumber1) {
            path = [NSString stringWithFormat:@"palsource_black/%d.png", cards[cardNumber]];
            _lastIsBlack = YES;
            return path;
        }
    }

    path = [NSString stringWithFormat:@"palsource/%d.png", cards[cardNumber]];
    _lastIsBlack = NO;
    return path;
}




@end


