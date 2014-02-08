//
//  FDBaseVC.h
//  iBolter
//
//  Created by Dong Yiming on 1/20/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDBaseVC : UIViewController

-(void)setupLayoutConstraints;

-(void)addConstraintsWithVFLString:(NSString *)aVFLString views:(NSDictionary *)aViewsDic;

-(void)addConstraintsWithVFLString:(NSString *)aVFLString options:(NSLayoutFormatOptions)aOptions views:(NSDictionary *)aViewsDic;

-(void)centerXInSuperView:(UIView *)aSubView;

-(void)centerYInSuperView:(UIView *)aSubView;
@end
