//
//  AFSelfieAPIClient.m
//  Selfie
//
//  Created by Thomas DeMeo on 9/9/15.
//  Copyright (c) 2015 Thomas DeMeo. All rights reserved.
//

#import "AFSelfieAPIClient.h"

@implementation AFSelfieAPIClient

+ (AFSelfieAPIClient *)sharedClient {
    static AFSelfieAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFSelfieAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kInstagramAPIURL]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    //    [self setDefaultHeader:@"Accept" value:@"application/json"];
    //    [self setDefaultHeader:@"format" value:@"json"];
    
    return self;
}

- (NSMutableURLRequest *)GETRequestWithParameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"GET" path:@"" parameters:parameters];
    return request;
}

@end
