//
//  PalUtil.m
//  PalCard
//
//  Created by Dong Yiming on 2/11/14.
//  Copyright (c) 2014 FlyinGeek. All rights reserved.
//

#import "PalUtil.h"
#import "UIImage+animatedGIF.h"

@implementation PalUtil

+(NSString *)mainBgMusicFile {
    return [[NSBundle mainBundle] pathForResource:@"main_bg.mp3" ofType:nil];
    //[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"main0%d.mp3", arc4random() % 2 + 1];
}

+(NSString *)freeOriginalImagePath:(NSUInteger)aNumber {
    return [NSString stringWithFormat:@"1Free/original/%d.png", aNumber];
}

+(NSString *)freePremiumImagePath:(NSUInteger)aNumber {
    return [NSString stringWithFormat:@"1Free/premium/%dp.gif", aNumber];
}

+(UIImage *)imageFromPath:(NSString *)aImagePath {
    
    if (aImagePath.length <= 0) {
        return nil;
    }
    
    if ([aImagePath.lowercaseString rangeOfString:@"gif"].location != NSNotFound) {
        //gif
        NSURL *url = [[NSBundle mainBundle] URLForResource:aImagePath withExtension:nil];
        return [UIImage animatedImageWithAnimatedGIFURL:url];
    } else {
        return [UIImage imageNamed:aImagePath];
    }
    
    return nil;
}


#pragma mark - version & build
+ (NSString *) appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

+ (NSString *) appBuild
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}

+ (NSString *) appVersionBuild
{
    NSString * version = [self appVersion];
    NSString * build = [self appBuild];
    
    NSString * versionBuild = [NSString stringWithFormat: @"v%@", version];
    
    if (![version isEqualToString: build]) {
        versionBuild = [NSString stringWithFormat: @"%@(%@)", versionBuild, build];
    }
    
    return versionBuild;
}

+(NSString *)appInfoUrl {
    NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    return [NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", bundleId];
}

+(void)appStoreVersionCheck {
    NSString *appInfoUrl = [self appInfoUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:appInfoUrl]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError && data.length) {
            id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                id results = [obj objectForKey:@"results"];
                if ([results isKindOfClass:[NSArray class]]) {
                    for (id result in results) {
                        if ([[[result objectForKey:@"trackId"] stringValue] isEqualToString:APP_STORE_ID]) {
                            NSString *info = [result objectForKey:@"version"];
                            NSLog(@"online version:%@, current version:%@", info, [self appVersion]);
                            break;
                        }
                    }
                }
            }
        }
    }];
}

@end
