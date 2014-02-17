//
//  YTVimeoExtractor.m
//  YTVimeoExtractor
//
//  Created by Louis Larpin on 18/02/13.
//

#import "YTVimeoExtractor.h"

NSString *const YTVimeoPlayerConfigURL = @"http://player.vimeo.com/v2/video/%@/config";
NSString *const YTVimeoExtractorErrorDomain = @"YTVimeoExtractorErrorDomain";

@interface YTVimeoExtractor () {
    NSMutableDictionary *_infoDic;
}

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *buffer;
@property (copy, nonatomic) completionHandler completionHandler;
@property (copy, nonatomic) VideoParseCallback callback;;

- (void)extractorFailedWithMessage:(NSString*)message errorCode:(int)code;

@end

@implementation YTVimeoExtractor

+ (void)fetchVideoURLFromURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality completionHandler:(completionHandler)handler
{
    YTVimeoExtractor *extractor = [[YTVimeoExtractor alloc] initWithURL:videoURL quality:quality];
    extractor.completionHandler = handler;
    [extractor start];
}

+ (void)fetchVideoURLFromID:(NSString *)videoID quality:(YTVimeoVideoQuality)quality completionHandler:(completionHandler)handler
{
    YTVimeoExtractor *extractor = [[YTVimeoExtractor alloc] initWithID:videoID quality:quality];
    extractor.completionHandler = handler;
    [extractor start];
}

+ (void)fetchVideoURLFromID:(NSString *)videoID callback:(VideoParseCallback)aCallback {
    YTVimeoExtractor *extractor = [[YTVimeoExtractor alloc] initWithID:videoID quality:YTVimeoVideoQualityHigh];
    extractor.callback = aCallback;
    [extractor start];
}

#pragma mark - Constructors

- (id)initWithID:(NSString *)videoID quality:(YTVimeoVideoQuality)quality
{
    self = [super init];
    if (self) {
        _ID = videoID;
        _vimeoURL = [NSURL URLWithString:[NSString stringWithFormat:YTVimeoPlayerConfigURL, videoID]];
        _quality = quality;
        _running = NO;
    }
    return self;
}

- (id)initWithURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality
{
    NSString *videoID = [[videoURL componentsSeparatedByString:@"/"] lastObject];
    return [self initWithID:videoID quality:quality];
}

- (void)dealloc
{
    [self.connection cancel];
    self.connection = nil;
    self.buffer = nil;
    self.delegate = nil;
}

#pragma mark - Public

- (void)start
{
    if (!(self.delegate || self.completionHandler || self.callback) || !self.vimeoURL) {
        [self extractorFailedWithMessage:@"Delegate, block or URL not specified" errorCode:YTVimeoExtractorErrorCodeNotInitialized];
        return;
    }
    if (self.running) {
        [self extractorFailedWithMessage:@"Already in progress" errorCode:YTVimeoExtractorErrorCodeNotInitialized];
        return;
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.vimeoURL];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    _running = YES;
}

# pragma mark - Private

- (void)extractorFailedWithMessage:(NSString*)message errorCode:(int)code {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:YTVimeoExtractorErrorDomain code:code userInfo:userInfo];
    
    if (self.completionHandler) {
        self.completionHandler(nil, error, self.quality);
    }
    else if (_callback) {
        _callback(_infoDic, error);
    }
    else if ([self.delegate respondsToSelector:@selector(vimeoExtractor:failedExtractingVimeoURLWithError:)]) {
        [self.delegate vimeoExtractor:self failedExtractingVimeoURLWithError:error];
    }
    _running = NO;
}

#pragma mark - NSURLConnectionDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSInteger statusCode = [httpResponse statusCode];
    if (statusCode != 200) {
        if (statusCode == 403) {
            [self extractorFailedWithMessage:@"Because of its privacy settings, this video cannot be played here." errorCode:YTVimeoExtractorErrorPrivate];
        } else {
            [self extractorFailedWithMessage:@"Invalid video indentifier" errorCode:YTVimeoExtractorErrorInvalidIdentifier];
        }
        
        [connection cancel];
    }
    
    NSUInteger capacity = (response.expectedContentLength != NSURLResponseUnknownLength) ? response.expectedContentLength : 0;
    self.buffer = [[NSMutableData alloc] initWithCapacity:capacity];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    NSString *jsonStr = [NSString stringWithUTF8String:self.buffer.bytes];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:self.buffer options:NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        [self extractorFailedWithMessage:@"Invalid video indentifier" errorCode:YTVimeoExtractorErrorInvalidIdentifier];
        return;
    }
    
    NSDictionary *filesInfo = [jsonData valueForKeyPath:@"request.files.h264"];
    if (!filesInfo) {
        [self extractorFailedWithMessage:@"Unsupported video codec" errorCode:YTVimeoExtractorErrorUnsupportedCodec];
        return;
    }
    
    //
    _infoDic = [NSMutableDictionary dictionary];
    NSString *title = [jsonData valueForKeyPath:@"video.title"];
    if (title.length) {
        [_infoDic setObject:title forKey:@"title"];
    }
    [_infoDic setObject:_ID forKey:@"id"];
    
    NSMutableDictionary *videoDic = [NSMutableDictionary dictionary];
    [_infoDic setObject:videoDic forKey:@"urls"];
    NSString *url = [[filesInfo objectForKey:@"mobile"] objectForKey:@"url"];
    if (url.length) {
        [videoDic setObject:url forKey:@"mobile"];
    }
    
    url = [[filesInfo objectForKey:@"sd"] objectForKey:@"url"];
    if (url.length) {
        [videoDic setObject:url forKey:@"sd"];
    }
    
    url = [[filesInfo objectForKey:@"hd"] objectForKey:@"url"];
    if (url.length) {
        [videoDic setObject:url forKey:@"hd"];
    }
    
    
    //
    NSDictionary *videoInfo;
    YTVimeoVideoQuality videoQuality = self.quality;
    do {
        videoInfo = [filesInfo objectForKey:@[ @"mobile", @"sd", @"hd" ][videoQuality]];
        videoQuality--;
    } while (!videoInfo && videoQuality >= YTVimeoVideoQualityLow);
    
    if (!videoInfo) {
        [self extractorFailedWithMessage:@"Unavailable video quality" errorCode:YTVimeoExtractorErrorUnavailableQuality];
        return;
    }
    
    NSURL *fileURL = [NSURL URLWithString:[videoInfo objectForKey:@"url"]];
    if (self.completionHandler) {
        self.completionHandler(fileURL, nil, videoQuality);
    }
    else if (_callback) {
        _callback(_infoDic, error);
    }
    else if ([self.delegate respondsToSelector:@selector(vimeoExtractor:didSuccessfullyExtractVimeoURL:withQuality:)]) {
        [self.delegate vimeoExtractor:self didSuccessfullyExtractVimeoURL:fileURL withQuality:videoQuality];
    }
    
    _running = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self extractorFailedWithMessage:[error localizedDescription] errorCode:YTVimeoExtractorErrorInvalidIdentifier];
}

@end
