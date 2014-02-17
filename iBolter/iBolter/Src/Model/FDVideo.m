//
//  FDVideo.m
//  iBolter
//
//  Created by Dong Yiming on 2/17/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "FDVideo.h"

@implementation FDVideo

-(id)initWithInfo:(NSDictionary *)aInfoDic {
    self = [super init];
    if (self) {
        _ID = [aInfoDic objectForKey:VIDEO_INFO_ID];
        _title = [aInfoDic objectForKey:VIDEO_INFO_TITLE];
        _urls = [aInfoDic objectForKey:VIDEO_INFO_URLS];
    }
    
    return self;
}

-(NSString *)url {
    if (_urls.allKeys.count) {
        return [_urls objectForKey:_urls.allKeys.firstObject];
    }
    
    return nil;
}

@end
