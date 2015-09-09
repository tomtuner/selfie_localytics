//
//  AFSelfieAPIClient.h
//  Selfie
//
//  Created by Thomas DeMeo on 9/9/15.
//  Copyright (c) 2015 Thomas DeMeo. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

#define kInstagramAPIURL @"https://api.instagram.com/v1/tags/selfie/media/recent"

@interface AFSelfieAPIClient : AFHTTPClient

+ (AFSelfieAPIClient *) sharedClient;
- (NSMutableURLRequest *)GETRequestWithParameters:(NSDictionary *) parameters;

@end
