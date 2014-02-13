//
//  WebViewController.h
//  YoutubeParser
//
//  Created by alex wang on 14-2-10.
//  Copyright (c) 2014年 Hiddencode.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCDownloadViewController.h"

@interface WebViewController : UIViewController <UITextFieldDelegate, HCDownloadViewControllerDelegate>

- (void)downloadVideo:(NSURL *)url;

@end
