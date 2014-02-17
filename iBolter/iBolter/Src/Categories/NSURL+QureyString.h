//
//  NSURL+QureyString.h
//  iBolter
//
//  Created by Dong Yiming on 2/17/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (QueryString)

/**
 Parses a query string of an NSURL
 
 @return key value dictionary with each parameter as an array
 */
- (NSMutableDictionary *)dictionaryForQueryString;

@end
