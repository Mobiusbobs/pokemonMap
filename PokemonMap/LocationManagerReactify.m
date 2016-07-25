//
//  LoclationManagerReactify.m
//  PokemonMap
//
//  Created by LinYiting on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "LocationManagerReactify.h"
#import <INTULocationManager/INTULocationManager.h>

@implementation LocationManagerReactify

+ (RACSignal *)currentLocationSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        INTULocationManager *locMgr = [INTULocationManager sharedInstance];
        [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyRoom
                                           timeout:5.0
                              delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                             block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                                 if (status == INTULocationStatusSuccess) {
                                                     [subscriber sendNext:currentLocation];
                                                     [subscriber sendCompleted];
                                                 }
                                                 else if (status == INTULocationStatusTimedOut) {
                                                   [subscriber sendError:[self errorWithDescription:@"TimeOut"]];
                                                 }
                                                 else {
                                                    [subscriber sendError:[self errorWithDescription:@"Error"]];
                                                 }
                                             }];

        return nil;
    }];
    
}


+ (NSError *)errorWithDescription:(NSString *)string
{
    NSString *domain = [NSBundle bundleForClass:[self class]].bundleIdentifier;
    NSString *description = string;
    return [NSError errorWithDomain:domain
                               code:0
                           userInfo:@{NSLocalizedDescriptionKey: description}];
}

@end
