//
//  PalAchievementBrain.m
//  PalCard
//
//  Created by FlyinGeek on 13-2-4.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalAchievementBrain.h"


@implementation PalAchievementBrain



+ (BOOL) newAchievementUnlocked: (NSString *)gameMode
                            win: (BOOL)win
                       timeUsed: (float)usedTime
                       timeLeft: (float)lastTime
                    wrongsTimes: (int)wrongs
                     rightTimes: (int)rights
              endWithBlackOrNot: (BOOL) endWithBlack

{
    bool flag = NO;
    
    
    // Get game data from UserDefault
    
    NSNumber *totalGames = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalGames"];
    NSNumber *totalWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalWins"];
    NSNumber *totalLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalLosses"];
    NSNumber *wins = [[NSUserDefaults standardUserDefaults] valueForKey:@"wins"];
    NSNumber *losses = [[NSUserDefaults standardUserDefaults] valueForKey:@"losses"];

    NSNumber *totalEasyWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalEasyWins"];
    NSNumber *totalNormalWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalNormalWins"];
    NSNumber *totalHardWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalHardWins"];
    NSNumber *totalFreeWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalFreeWins"];
    
    NSNumber *totalEasyLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalEasyLosses"];
    NSNumber *totalNormalLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalNormalLosses"];
    NSNumber *totalHardLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalHardLosses"];
    NSNumber *totalFreeLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalFreeLosses"];

    NSNumber *easyWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"easyWins"];
    NSNumber *normalWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"normalWins"];
    NSNumber *hardWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"hardWins"];
    NSNumber *freeWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"freeWins"];
    
    NSNumber *easyLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"easyLosses"];
    NSNumber *normalLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"normalLosses"];
    NSNumber *hardLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"hardLosses"];
    NSNumber *freeLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"freeLosses"];
    
    
    // calculate new game data 
    totalGames = [NSNumber numberWithInteger:[totalGames integerValue] + 1];
    
    if (win) {
        
        totalWins = [NSNumber numberWithInteger:[totalWins integerValue] + 1];
        wins = [NSNumber numberWithInteger:[wins integerValue] + 1];
        losses = [NSNumber numberWithInteger:0];
        
        if ([gameMode isEqualToString:@"easy"]) {
            totalEasyWins = [NSNumber numberWithInteger:[totalEasyWins integerValue] + 1];
            easyWins = [NSNumber numberWithInteger:[easyWins integerValue] + 1];
            easyLosses = [NSNumber numberWithInteger:0];
        }
        if ([gameMode isEqualToString:@"normal"]) {
            totalNormalWins = [NSNumber numberWithInteger:[totalNormalWins integerValue] + 1];
            normalWins = [NSNumber numberWithInteger:[normalWins integerValue] + 1];
            normalLosses = [NSNumber numberWithInteger:0];
        }
        if ([gameMode isEqualToString:@"hard"]) {
            totalHardWins = [NSNumber numberWithInteger:[totalHardWins integerValue] + 1];
            hardWins = [NSNumber numberWithInteger:[hardWins integerValue] + 1];
            hardLosses = [NSNumber numberWithInteger:0];
        }
        if ([gameMode isEqualToString:@"freeStyle"]) {
            totalFreeWins = [NSNumber numberWithInteger:[totalFreeWins integerValue] + 1];
            freeWins = [NSNumber numberWithInteger:[freeWins integerValue] + 1];
            freeLosses = [NSNumber numberWithInteger:0];
        }
    }
    
    if (!win) {
        
        totalLosses = [NSNumber numberWithInteger:[totalLosses integerValue] + 1];
        losses = [NSNumber numberWithInteger:[losses integerValue] + 1];
        wins = [NSNumber numberWithInteger:0];
        
        if ([gameMode isEqualToString:@"easy"]) {
            totalEasyLosses = [NSNumber numberWithInteger:[totalEasyLosses integerValue] + 1];
            easyLosses = [NSNumber numberWithInteger:[easyLosses integerValue] + 1];
            easyWins = [NSNumber numberWithInteger:0];
        }
        if ([gameMode isEqualToString:@"normal"]) {
            totalNormalLosses = [NSNumber numberWithInteger:[totalNormalLosses integerValue] + 1];
            normalLosses = [NSNumber numberWithInteger:[normalLosses integerValue] + 1];
            normalWins = [NSNumber numberWithInteger:0];
        }
        if ([gameMode isEqualToString:@"hard"]) {
            totalHardLosses = [NSNumber numberWithInteger:[totalHardLosses integerValue] + 1];
            hardLosses = [NSNumber numberWithInteger:[hardLosses integerValue] + 1];
            hardWins = [NSNumber numberWithInteger:0];
        }
        if ([gameMode isEqualToString:@"freeStyle"]) {
            totalFreeLosses = [NSNumber numberWithInteger:[totalFreeLosses integerValue] + 1];
            freeLosses = [NSNumber numberWithInteger:[freeLosses integerValue] + 1];
            freeWins = [NSNumber numberWithInteger:0];
        }
    }
    
    // read card unlock information for userdefault

    NSMutableArray *CardIsUnlocked = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"CardIsUnlocked"]];

 
    // achievement brain
    
    int cardCount = CardIsUnlocked.count;
    for (int i = 0; i < cardCount; i++) {
        BOOL isUnlocked = [(CardIsUnlocked[i]) boolValue];
        if (!isUnlocked && totalWins.intValue > i * (i / 2 + 1)) {
            CardIsUnlocked[i] = @1;
            flag = YES;
        }
    }
    
    
    // Store new game data in userdefaults
    
    [[NSUserDefaults standardUserDefaults] setValue:CardIsUnlocked forKey:@"CardIsUnlocked"];
    
    [[NSUserDefaults standardUserDefaults] setValue:totalGames forKey:@"totalGames"];
    [[NSUserDefaults standardUserDefaults] setValue:totalWins forKey:@"totalWins"];
    [[NSUserDefaults standardUserDefaults] setValue:totalLosses forKey:@"totalLosses"];
    [[NSUserDefaults standardUserDefaults] setValue:wins forKey:@"wins"];
    [[NSUserDefaults standardUserDefaults] setValue:losses forKey:@"losses"];
    

    [[NSUserDefaults standardUserDefaults] setValue:totalEasyWins forKey:@"totalEasyWins"];
    [[NSUserDefaults standardUserDefaults] setValue:totalNormalWins forKey:@"totalNormalWins"];
    [[NSUserDefaults standardUserDefaults] setValue:totalHardWins forKey:@"totalHardWins"];
    [[NSUserDefaults standardUserDefaults] setValue:totalFreeWins forKey:@"totalFreeWins"];

    [[NSUserDefaults standardUserDefaults] setValue:totalEasyLosses forKey:@"totalEasyLosses"];
    [[NSUserDefaults standardUserDefaults] setValue:totalNormalLosses  forKey:@"totalNormalLosses"];
    [[NSUserDefaults standardUserDefaults] setValue:totalHardLosses forKey:@"totalHardLosses"];
    [[NSUserDefaults standardUserDefaults] setValue:totalFreeLosses forKey:@"totalFreeLosses"];
    
    [[NSUserDefaults standardUserDefaults] setValue:easyWins forKey:@"easyWins"];
    [[NSUserDefaults standardUserDefaults] setValue:normalWins forKey:@"normalWins"];
    [[NSUserDefaults standardUserDefaults] setValue:hardWins forKey:@"hardWins"];
    [[NSUserDefaults standardUserDefaults] setValue:freeWins forKey:@"freeWins"];
    
    [[NSUserDefaults standardUserDefaults] setValue:easyLosses forKey:@"easyLosses"];
    [[NSUserDefaults standardUserDefaults] setValue:normalLosses forKey:@"normalLosses"];
    [[NSUserDefaults standardUserDefaults] setValue:hardLosses forKey:@"hardLosses"];
    [[NSUserDefaults standardUserDefaults] setValue:freeLosses forKey:@"freeLosses"];
    
    return flag;
}



@end
