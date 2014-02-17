//
//  FDVimeoVideo.m
//  iBolter
//
//  Created by Dong Yiming on 2/17/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "FDVimeoVideo.h"

@implementation FDVimeoVideo
-(id)initWithInfo:(NSDictionary *)aInfoDic {
    self = [super initWithInfo:aInfoDic];
    if (self) {
        _type = kVideoTypeVimeo;
    }
    
    return self;
}

-(NSString *)url {
    NSDictionary *urls = self.urls;
    if (urls.allKeys.count) {
        NSString *url = [urls objectForKey:VIDEO_QUALITY_HD];
        if (url.length <= 0) {
            url = [urls objectForKey:VIDEO_QUALITY_SD];
            if (url.length <= 0) {
                url = [urls objectForKey:VIDEO_QUALITY_MOBILE];
            }
        }
        
        return url;
    }
    
    return nil;
}
@end
