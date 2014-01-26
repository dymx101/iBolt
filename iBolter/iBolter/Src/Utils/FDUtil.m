//
//  FDUtil.m
//  iBolter
//
//  Created by Dong Yiming on 1/26/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "FDUtil.h"

@implementation FDUtil

+ (NSString *) appDirDoc
{
    static NSString *dirStr = nil;
    if (dirStr == nil) {
        dirStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    }
    return dirStr;
}

@end
