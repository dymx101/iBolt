//
//  FDBaseVC.m
//  iBolter
//
//  Created by Dong Yiming on 1/20/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "FDBaseVC.h"

@interface FDBaseVC ()

@end

@implementation FDBaseVC

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
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}


-(void)setupLayoutConstraints {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - helper
-(void)addConstraintsWithVFLString:(NSString *)aVFLString views:(NSDictionary *)aViewsDic {
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:aVFLString options:0 metrics:nil views:aViewsDic];
    [self.view addConstraints:constraints];
}

@end
