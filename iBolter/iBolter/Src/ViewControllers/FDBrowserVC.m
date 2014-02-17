//
//  FDBrowserVC.m
//  iBolter
//
//  Created by Dong Yiming on 1/20/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "FDBrowserVC.h"
#import "FDWebViewWacher.h"

@interface FDBrowserVC () <UIWebViewDelegate, UITextFieldDelegate> {
    UIWebView           *_webview;
    UIView              *_topBar;
    UITextField         *_tfURL;
    
    NSString            *_currentURL;
    FDWebViewWacher     *_webWatcher;
}

@end

@implementation FDBrowserVC

-(void)dealloc {
    [_webWatcher stop];
}

- (void)viewDidLoad
{
    [self observeNotification:DF_NOTIFY_URL_REQUEST];
    
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
    
    // create web watcher
    _webWatcher = [[FDWebViewWacher alloc] initWithWebView:_webview];
    [_webWatcher start];
    
    [self setupLayoutConstraints];
    
    [self loadURL:@"http://youtube.com"];
}

-(void)viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
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
    [self addConstraintsWithVFLString:@"|[_topBar]|" views:viewsDictionary];
    [self addConstraintsWithVFLString:@"|[_webview]|" views:viewsDictionary];
    [self addConstraintsWithVFLString:@"V:|-20-[_topBar(44)][_webview]|" views:viewsDictionary];
    
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
//    NSString *html = [webView stringByEvaluatingJavaScriptFromString:
//                      @"document.body.innerHTML"];
//    DLog(@"%@", html);
    
    [SVProgressHUD dismiss];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    _currentURL = request.URL.absoluteString;
    DLog(@"URL:%@", _currentURL);
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    _tfURL.text = _currentURL;
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

#pragma mark - notification handling
-(void)handleNotification:(NSNotification *)notification {
    NSString *name = notification.name;
    if ([name isEqualToString:DF_NOTIFY_URL_REQUEST]) {
        NSString *requestURL = notification.object;
        DLog(@"%@", requestURL);
    }
}

@end
