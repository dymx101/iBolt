//
//  WebViewController.m
//  YoutubeParser
//
//  Created by alex wang on 14-2-10.
//  Copyright (c) 2014年 Hiddencode.me. All rights reserved.
//

#import "WebViewController.h"
#import "HCYoutubeParser.h"
#import "HCDownloadViewController.h"
#import <MediaPlayer/MPMoviePlayerViewController.h>

@interface WebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *web;
@property (weak, nonatomic) IBOutlet UITextField *url;

- (IBAction)analyseUrl:(id)sender;

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.web.delegate = self;
    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url.text]]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url.text]]];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)analyseUrl:(id)sender
{
    NSString* htmlString = [self.web stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    if (htmlString) {
        NSString *youTubeID = @"data-youtube-id=\"";
        int position = [htmlString rangeOfString:youTubeID].location + [youTubeID length];
        if (position > 1) {
            htmlString = [htmlString substringFromIndex:position];
            position = [htmlString rangeOfString:@"\""].location;
            htmlString = [htmlString substringToIndex:position];
            //NSString* tempPrefix = @"http://m.youtube.com/watch?v=";
            //NSString *youTubeString = [tempPrefix stringByAppendingString:htmlString];
            //textFieldView.text = youTubeString;
            
            NSLog(@"URL: %@", htmlString);
            
            NSDictionary *videos = [HCYoutubeParser h264videosWithYoutubeID:htmlString];
            /*
            MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[videos objectForKey:@"medium"]]];
            
            [self presentModalViewController:mp animated:YES];
            */
            
            [self downloadVideo:[NSURL URLWithString:[videos objectForKey:@"medium"]]];
        } else {
            //[[SharedObjectsSingleton sharedInstance] displayAlert:@"Can't Copy URL" :@"Can only copy the URL when a single video is being displayed."];
        }
    } else {
        //:@"Can't get URL" :@"Nothing to copy."];
    }
}

- (void)downloadVideo:(NSURL *)url
{
    HCDownloadViewController *dvc = [HCDownloadViewController new];
    
    dvc.downloadDirectory = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
    dvc.delegate = self;
    
    [dvc downloadURL:url userInfo:nil];
    
    [self presentViewController:dvc animated:YES completion:NULL];
}

#pragma mark - webview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"shouldStartLoadWithRequest");
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
        NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
        NSLog(@"webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
        NSLog(@"didFailLoadWithError");
}

@end
