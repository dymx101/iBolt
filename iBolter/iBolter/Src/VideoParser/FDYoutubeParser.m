//
//  FDYoutubeParser.m
//  iBolter
//
//  Created by Dong Yiming on 2/17/14.
//  Copyright (c) 2014 Frodo. All rights reserved.
//

#import "FDYoutubeParser.h"
#import "NSURL+QureyString.h"
#import "NSString+QureyString.h"

#define kYoutubeInfoURL         @"http://www.youtube.com/get_video_info?video_id="
#define kYoutubeThumbnailURL    @"http://img.youtube.com/vi/%@/%@.jpg"
#define kYoutubeDataURL         @"http://gdata.youtube.com/feeds/api/videos/%@?alt=json"
#define kUserAgent              @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4"

static NSString *youtubeIdKey = @"data-youtube-id=\"";

@implementation FDYoutubeParser
+(NSDictionary *)parseHtml:(NSString *)aHtml {
    NSString *youtubeID = [self videoIdFromHtml:aHtml];
    
    return [self videosWithYoutubeID:youtubeID];
}

+(NSString *)videoIdFromHtml:(NSString *)aHtml {
    if (aHtml.length) {
        int position = [aHtml rangeOfString:youtubeIdKey].location + youtubeIdKey.length;
        
        if (position > 1) {
            aHtml = [aHtml substringFromIndex:position];
            
            position = [aHtml rangeOfString:@"\""].location;
            aHtml = [aHtml substringToIndex:position];
            
            return aHtml;
        }
    }
    
    return nil;
}

+ (NSDictionary *)videosWithYoutubeID:(NSString *)youtubeID {
    if (youtubeID) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kYoutubeInfoURL, youtubeID]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:kUserAgent forHTTPHeaderField:@"User-Agent"];
        [request setHTTPMethod:@"GET"];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (!error) {
            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *parts = [responseString dictionaryFromQueryStringComponents];
            NSMutableDictionary *videoDictionary = [NSMutableDictionary dictionary];
            
            NSArray *titleArr = [parts objectForKey:YOUTUBE_INFO_TITLE];
            if (titleArr.count) {
                [videoDictionary setObject:titleArr.firstObject forKey:YOUTUBE_INFO_TITLE];
            }
            
            if (parts) {
                NSString *fmtStreamMapString = [[parts objectForKey:@"url_encoded_fmt_stream_map"] objectAtIndex:0];
                
                if (fmtStreamMapString.length > 0) {
                    
                    NSArray *fmtStreamMapArray = [fmtStreamMapString componentsSeparatedByString:@","];
                    
                    for (NSString *videoEncodedString in fmtStreamMapArray) {
                        NSMutableDictionary *videoComponents = [videoEncodedString dictionaryFromQueryStringComponents];
                        NSString *type = [[[videoComponents objectForKey:@"type"] objectAtIndex:0] stringByDecodingURLFormat];
                        NSString *signature = nil;
                        
                        if (![videoComponents objectForKey:@"stereo3d"]) {
                            if ([videoComponents objectForKey:@"sig"]) {
                                signature = [[videoComponents objectForKey:@"sig"] objectAtIndex:0];
                            }
                            
                            if (signature && [type rangeOfString:@"mp4"].length > 0) {
                                NSString *url = [[[videoComponents objectForKey:@"url"] objectAtIndex:0] stringByDecodingURLFormat];
                                url = [NSString stringWithFormat:@"%@&signature=%@", url, signature];
                                
                                NSString *quality = [[[videoComponents objectForKey:@"quality"] objectAtIndex:0] stringByDecodingURLFormat];
                                if ([videoComponents objectForKey:@"stereo3d"] && [[videoComponents objectForKey:@"stereo3d"] boolValue]) {
                                    quality = [quality stringByAppendingString:@"-stereo3d"];
                                }
                                if([videoDictionary valueForKey:quality] == nil) {
                                    [videoDictionary setObject:url forKey:quality];
                                }
                            }
                        }
                    }
                    return videoDictionary;
                }
                // Check for live data
                else if ([parts objectForKey:@"live_playback"] != nil && [parts objectForKey:@"hlsvp"] != nil && [[parts objectForKey:@"hlsvp"] count] > 0) {
                    return @{ @"live": [parts objectForKey:@"hlsvp"][0] };
                }
            }
        }
    }
    return nil;
}

@end
