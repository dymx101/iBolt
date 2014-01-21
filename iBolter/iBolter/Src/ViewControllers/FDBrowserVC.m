//
//  FDBrowserVC.m
//  iBolter
//
//  Created by Dong Yiming on 1/20/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "FDBrowserVC.h"

@interface FDBrowserVC () <UIWebViewDelegate, UITextFieldDelegate> {
    UIWebView           *_webview;
    UIView     *_topBar;
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
    _topBar = [UIView new];
    _topBar.backgroundColor = FDColor.sharedInstance.white;
    [self.view addSubview:_topBar];
    
    // create url text field
    _tfURL = [UITextField new];
    _tfURL.delegate = self;
    _tfURL.backgroundColor = FDColor.sharedInstance.silver;
    _tfURL.keyboardType = UIKeyboardTypeEmailAddress;
    _tfURL.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _tfURL.returnKeyType = UIReturnKeyGo;
    _tfURL.clearButtonMode = UITextFieldViewModeAlways;
    [_topBar addSubview:_tfURL];
    
    // create web view
    _webview = [UIWebView new];
    _webview.delegate = self;
    [self.view addSubview:_webview];
    
    [self setupLayoutConstraints];
    
    [self loadURL:@"http://www.baidu.com"];
}

-(void)loadURL:(NSString *)aURL {
    if (aURL.length) {
        if ([aURL.lowercaseString rangeOfString:@"http://"].location == NSNotFound
            && [aURL.lowercaseString rangeOfString:@"https://"].location == NSNotFound) {
            aURL = [NSString stringWithFormat:@"http://%@", aURL];
        }
        NSURL *url = [NSURL URLWithString:aURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webview loadRequest:request];
    }
}

-(void)setupLayoutConstraints {
    _topBar.translatesAutoresizingMaskIntoConstraints = NO;
    _webview.translatesAutoresizingMaskIntoConstraints = NO;
    _tfURL.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_topBar, _webview);
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_topBar]|" options:0
                                                                   metrics:nil
                                                                     views:viewsDictionary];
    [self.view addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_webview]|" options:0
                                                                   metrics:nil
                                                                     views:viewsDictionary];
    [self.view addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_topBar(44)][_webview]|" options:0
                                                          metrics:nil
                                                            views:viewsDictionary];
    [self.view addConstraints:constraints];
    
    // text field lay out constraints
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_tfURL attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_topBar attribute:NSLayoutAttributeLeading multiplier:1 constant:10];
    [_topBar addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_tfURL attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_topBar attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10];
    [_topBar addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_tfURL attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topBar attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [_topBar addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_tfURL attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
    [_tfURL addConstraint:constraint];
    
//    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_tfURL(44)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tfURL)];
//    [_topBar addConstraints:constraints];
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

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length) {
        [self loadURL:textField.text];
        [textField resignFirstResponder];
    }
    return YES;
}

@end
