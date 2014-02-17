//
//  NSURL+QureyString.m
//  iBolter
//
//  Created by Dong Yiming on 2/17/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "NSURL+QureyString.h"
#import "NSString+QureyString.h"

@implementation NSURL (QueryString)

- (NSMutableDictionary *)dictionaryForQueryString {
    return [[self query] dictionaryFromQueryStringComponents];
}

@end
