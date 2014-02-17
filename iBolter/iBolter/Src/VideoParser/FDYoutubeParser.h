//
//  FDYoutubeParser.h
//  iBolter
//
//  Created by Dong Yiming on 2/17/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDVideoParser.h"

@interface FDYoutubeParser : FDVideoParser
+(NSDictionary *)parseHtml:(NSString *)aHtml;
@end

#define YOUTUBE_QUALITY_MEDIUM  @"medium"
#define YOUTUBE_QUALITY_SMALL   @"small"
#define YOUTUBE_QUALITY_LIVE    @"live"

#define YOUTUBE_INFO_TITLE    @"title"