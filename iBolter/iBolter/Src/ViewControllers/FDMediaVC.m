//
//  FDMediaVC.m
//  iBolter
//
//  Created by Dong Yiming on 1/20/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "FDMediaVC.h"
#import "FDMoviePlayerVC.h"

@interface FDMediaVC ()

@end

@implementation FDMediaVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = FDColor.sharedInstance.desertSand;
    self.title = @"Media";
    
    UIButton *testButton = [UIButton new];
    [testButton addTarget:self action:@selector(testMoviePlayer) forControlEvents:UIControlEventTouchUpInside];
    [testButton setTitle:@"Test Movie" forState:UIControlStateNormal];
    [testButton setTitleColor:FDColor.sharedInstance.black forState:UIControlStateNormal];
    testButton.backgroundColor = FDColor.sharedInstance.white;
    [self.view addSubview:testButton];
    
    testButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *vflDic = NSDictionaryOfVariableBindings(testButton);
    [self addConstraintsWithVFLString:@"[testButton(==100)]" options:0 views:vflDic];
    [self addConstraintsWithVFLString:@"V:[testButton(==30)]" options:0 views:vflDic];
    [self centerXInSuperView:testButton];
    [self centerYInSuperView:testButton];
    
}

-(void)testMoviePlayer {
    UIViewController *vc = [FDMoviePlayerVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
