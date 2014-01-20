//
//  FDMenuVC.m
//  iBolter
//
//  Created by Dong Yiming on 1/20/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "FDMenuVC.h"

static NSArray *g_testDatas;

@interface FDMenuVC () <UITableViewDelegate, UITableViewDataSource> {
    UITableView     *_tv;
}

@end

@implementation FDMenuVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = FDColor.sharedInstance.magicMint;
    g_testDatas = @[@"Browser", @"Downloads", @"Media", @"Playlist", @"Settings"];
    
    _tv = [UITableView new];
    _tv.translatesAutoresizingMaskIntoConstraints = NO;
    _tv.delegate = self;
    _tv.dataSource = self;
    [self.view addSubview:_tv];
    
    [self setupLayoutConstraints];
}

#pragma mark - setup table view layout
-(void)setupLayoutConstraints {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_tv
                                                                  attribute:NSLayoutAttributeRight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0f constant:0.0f];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_tv
                                              attribute:NSLayoutAttributeLeft
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeLeft
                                             multiplier:1.0f constant:0.0f];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_tv
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1.0f constant:0.0f];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_tv
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0f constant:0.0f];
    [self.view addConstraint:constraint];
}


#pragma mark - table view datasource
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return g_testDatas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = g_testDatas[indexPath.row];
    
    return cell;
}

#pragma mark - table view delegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self postNotification:DF_NOTIFY_CLOSE_DRAWER];
}

@end
