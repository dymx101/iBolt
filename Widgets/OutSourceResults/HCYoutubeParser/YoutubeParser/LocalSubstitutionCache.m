//
//  LocalSubstitutionCache.m
//  LocalSubstitutionCache
//
//  Created by Matt Gallagher on 2010/09/06.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "LocalSubstitutionCache.h"

#define MEMORY_CACHE_SIZE       (20 * 1024 * 1024)
#define DISK_CACHE_SIZE         (200 * 1024 * 1024)

@implementation LocalSubstitutionCache


- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{
	//
	// Get the path for the request
	//
	NSString *pathString = [[request URL] absoluteString];
	NSLog(@"[%@]", pathString);
    
    return [super cachedResponseForRequest:request];
}

- (void)removeCachedResponseForRequest:(NSURLRequest *)request
{
	[super removeCachedResponseForRequest:request];
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
