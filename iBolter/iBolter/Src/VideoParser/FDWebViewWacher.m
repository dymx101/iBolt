//
//  FDWebWacher.m
//  iBolter
//
//  Created by Dong Yiming on 2/17/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "FDWebViewWacher.h"
#import "FDYoutubeParser.h"

#define CHECK_INTERVAL      (5.f)

@interface FDWebViewWacher () {
    UIWebView       *_webView;
    NSTimer         *_timer;
    NSString        *_oldHtml;
}

@end

@implementation FDWebViewWacher

-(id)initWithWebView:(UIWebView *)aWebView {
    self = [super init];
    if (self) {
        _webView = aWebView;
    }
    
    return self;
}

-(void)start {
    [self stop];
    _timer = [NSTimer scheduledTimerWithTimeInterval:CHECK_INTERVAL target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

-(void)stop {
    [_timer invalidate];
    _timer = nil;
}

-(void)tick:(id)sender {
    NSString *html = [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    if (html.length && ![html isEqualToString:_oldHtml]) {
        // start analysis
        FDYoutubeVideo *video = [FDYoutubeParser parseHtml:html];
        DLog(@"%@", video.url);
    }
    _oldHtml = html;
}

@end
