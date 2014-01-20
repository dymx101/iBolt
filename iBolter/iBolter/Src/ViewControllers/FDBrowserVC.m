//
//  FDBrowserVC.m
//  iBolter
//
//  Created by Dong Yiming on 1/20/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "FDBrowserVC.h"

@interface FDBrowserVC () <UIWebViewDelegate> {
    UIWebView   *_webview;
}

@end

@implementation FDBrowserVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = FDColor.sharedInstance.purpleHeart;
    self.title = @"Browser";
    
    _webview = [UIWebView new];
    _webview.delegate = self;
    [self.view addSubview:_webview];
    [self setupLayoutConstraints];
    
    [self loadURL:@"http://www.baidu.com"];
}

-(void)loadURL:(NSString *)aURL {
    if (aURL.length) {
        NSURL *url = [NSURL URLWithString:aURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webview loadRequest:request];
    }
}

-(void)setupLayoutConstraints {
    _webview.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_webview);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_webview]|" options:0
                                                                   metrics:nil
                                                                     views:viewsDictionary];
    [self.view addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_webview]|" options:0
                                                          metrics:nil
                                                            views:viewsDictionary];
    [self.view addConstraints:constraints];
}


#pragma mark - web view delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:
                      @"document.body.innerHTML"];
    DLog(@"%@", html);
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    
}

@end
