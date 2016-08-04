//
//  APIClient.m
//  Anchor
//
//  Created by Ray Shih on 1/15/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

+ (instancetype)sharedClient
{
    static APIClient *client = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        client = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://map_api.goradar.io"]];
    });
    
    return client;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setTimeoutInterval:90.0];

    }
    
    return self;
}

// It's safe!
// see this
// `Is it safe to override a Category-defined method in Objective-C?`
// http://stackoverflow.com/questions/18513403/is-it-safe-to-override-a-category-defined-method-in-objective-c
- (RACSignal *)rac_GET:(NSString *)path parameters:(id)parameters
{
    return [[super rac_GET:path parameters:parameters] doError:^(NSError *error) {
    }];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters
{
    return [[super rac_POST:path parameters:parameters] doError:^(NSError *error) {
    }];
}

- (RACSignal *)rac_PUT:(NSString *)path parameters:(id)parameters
{
    return [[super rac_PUT:path parameters:parameters] doError:^(NSError *error) {
    }];
}

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id)parameters
{
    return [[super rac_DELETE:path parameters:parameters] doError:^(NSError *error) {
    }];
}


@end
