//
//  FDWebWacher.m
//  iBolter
//
//  Created by Dong Yiming on 2/17/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "FDWebViewWacher.h"
#import "FDYoutubeParser.h"
#import "FDVimeoVideo.h"

#import "GGPredicate.h"

#define YOUTUBE_COM         @"youtube.com"
#define VIMEO_COM           @"vimeo.com"

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
        // -------> start analysis
        //NSString *url = _webView.request.URL.absoluteString;
        //NSString *mainDocURL = _webView.request.mainDocumentURL.absoluteString;
        NSString *currentURL = [_webView stringByEvaluatingJavaScriptFromString:@"window.location.href"].lowercaseString;
        
        if ([currentURL rangeOfString:YOUTUBE_COM].location != NSNotFound) {
            
            FDYoutubeVideo *video = [FDYoutubeParser parseHtml:html];
            DLog(@"Video Address:---> %@", video.url);
            
        } else if ([currentURL rangeOfString:VIMEO_COM].location != NSNotFound) {
            
            NSString *videoID = [[currentURL componentsSeparatedByString:@"/"] lastObject];
            if ([GGPredicate checkNumeric:videoID] && videoID.length == 8) {
                
//                [YTVimeoExtractor fetchVideoURLFromID:videoID quality:YTVimeoVideoQualityHigh completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
//                    if (!error) {
//                        DLog(@"Video Address:---> %@", videoURL.absoluteString);
//                    }
//                }];
                
                [YTVimeoExtractor fetchVideoURLFromID:videoID callback:^(NSDictionary *aInfoDic, NSError *anError) {
                    if (!anError && aInfoDic) {
                        FDVimeoVideo *video = [[FDVimeoVideo alloc] initWithInfo:aInfoDic];
                        DLog(@"Video Address:---> %@", video.url);
                    }
                }];
            }
        }
    }
    _oldHtml = html;
}

@end
