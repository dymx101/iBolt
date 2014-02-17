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
-(id)parseHtml:(NSString *)aHtml;
@end
