//
//  FDYoutubeParser.m
//  iBolter
//
//  Created by Dong Yiming on 2/17/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "FDYoutubeParser.h"

static NSString *youtubeIdKey = @"data-youtube-id=\"";

@implementation FDYoutubeParser
-(id)parseHtml:(NSString *)aHtml {
    NSString *youtubeID = [self videoIdFromHtml:aHtml];
    return nil;
}

-(NSString *)videoIdFromHtml:(NSString *)aHtml {
    if (aHtml.length) {
        int position = [aHtml rangeOfString:youtubeIdKey].location + youtubeIdKey.length;
        
        if (position > 1) {
            aHtml = [aHtml substringFromIndex:position];
            
            position = [aHtml rangeOfString:@"\""].location;
            aHtml = [aHtml substringToIndex:position];
            
            return aHtml;
        }
    }
    
    return nil;
}
@end
