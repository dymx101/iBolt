//
//  FDBrowserVC.m
//  iBolter
//
//  Created by Dong Yiming on 1/20/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "FDBrowserVC.h"

@interface FDBrowserVC () <UIWebViewDelegate> {
    UIWebView           *_webview;
    UINavigationBar     *_topBar;
    UITextField         *_tfURL;
}

@end

@implementation FDBrowserVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = FDColor.sharedInstance.purpleHeart;
    self.title = @"Browser";
    
    // hide navigation bar
    self.navigationController.navigationBarHidden = YES;
    
    // create top bar
    _topBar = [UINavigationBar new];
    _topBar.tintColor = FDColor.sharedInstance.midnightBlue;
    [self.view addSubview:_topBar];
    
    // create web view
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
    _topBar.translatesAutoresizingMaskIntoConstraints = NO;
    _webview.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_topBar, _webview);
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_topBar]-|" options:0
                                                                   metrics:nil
                                                                     views:viewsDictionary];
    [self.view addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_webview]|" options:0
                                                                   metrics:nil
                                                                     views:viewsDictionary];
    [self.view addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_topBar(44)]-[_webview]|" options:0
                                                          metrics:nil
                                                            views:viewsDictionary];
    [self.view addConstraints:constraints];
}


#pragma mark - web view delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:
                      @"document.body.innerHTML"];
    DLog(@"%@", html);
    [SVProgressHUD dismiss];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD showWithStatus:@"Loading..."];
}

@end
