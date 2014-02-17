//
//  FDWebWacher.h
//  iBolter
//
//  Created by Dong Yiming on 2/17/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDWebViewWacher : NSObject
-(id)initWithWebView:(UIWebView *)aWebView;
-(void)start;
-(void)stop;
@end
