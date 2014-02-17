//
//  FDYoutubeVideo.m
//  iBolter
//
//  Created by Dong Yiming on 2/17/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "FDYoutubeVideo.h"

@implementation FDYoutubeVideo

-(NSString *)url {
    NSDictionary *urls = self.urls;
    if (urls.allKeys.count) {
        NSString *url = [urls objectForKey:VIDEO_QUALITY_MEDIUM];
        if (url.length <= 0) {
            url = [urls objectForKey:VIDEO_QUALITY_SMALL];
        }
        
        return url;
    }
    
    return nil;
}
@end
