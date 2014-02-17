//
//  FDVideo.h
//  iBolter
//
//  Created by Dong Yiming on 2/17/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kVideoTypeYoutube = 0
    , kVideoTypeVimeo
}EVideoType;

@interface FDVideo : NSObject {
 @protected
    EVideoType _type;
}
@property (nonatomic, assign) EVideoType        type;
@property (nonatomic, assign) NSString          *ID;
@property (nonatomic, copy)     NSString        *title;
@property (nonatomic, strong)   NSDictionary    *urls;

-(id)initWithInfo:(NSDictionary *)aInfoDic;
-(NSString *)url;
@end
