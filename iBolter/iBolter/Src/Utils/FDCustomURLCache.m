
#import "FDCustomURLCache.h"

#define MEMORY_CACHE_SIZE       (20 * 1024 * 1024)
#define DISK_CACHE_SIZE         (200 * 1024 * 1024)

@implementation FDCustomURLCache


- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{
	NSString *pathString = [[request URL] absoluteString];

    [self postNotification:DF_NOTIFY_URL_REQUEST withObject:pathString];
    
    return [super cachedResponseForRequest:request];
}


- (id)init
{
    self = [super initWithMemoryCapacity:MEMORY_CACHE_SIZE
                            diskCapacity:DISK_CACHE_SIZE
                                diskPath:nil];
    if (self) {
        
    }
    return self;
}

@end
