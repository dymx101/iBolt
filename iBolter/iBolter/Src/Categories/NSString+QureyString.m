//
//  NSString+QureyString.m
//  iBolter
//
//  Created by Dong Yiming on 2/17/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "NSString+QureyString.h"

@implementation NSString (QureyString)

- (NSString *)stringByDecodingURLFormat {
    NSString *result = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (NSMutableDictionary *)dictionaryFromQueryStringComponents {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    for (NSString *keyValue in [self componentsSeparatedByString:@"&"]) {
        NSArray *keyValueArray = [keyValue componentsSeparatedByString:@"="];
        if ([keyValueArray count] < 2) {
            continue;
        }
        
        NSString *key = [[keyValueArray objectAtIndex:0] stringByDecodingURLFormat];
        NSString *value = [[keyValueArray objectAtIndex:1] stringByDecodingURLFormat];
        
        NSMutableArray *results = [parameters objectForKey:key];
        
        if(!results) {
            results = [NSMutableArray arrayWithCapacity:1];
            [parameters setObject:results forKey:key];
        }
        
        [results addObject:value];
    }
    
    return parameters;
}

@end
