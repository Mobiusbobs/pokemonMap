//
//  APIClient.h
//  Anchor
//
//  Created by Ray Shih on 1/15/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import <AFHTTPSessionManager.h>
#import <AFNetworking-RACExtensions/AFHTTPSessionManager+RACSupport.h>

@interface APIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
- (instancetype)initWithBaseURL:(NSURL *)url;

@end
