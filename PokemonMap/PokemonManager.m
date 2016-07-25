//
//  PokemonManager.m
//  PokemonMap
//
//  Created by LinYiting on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "PokemonManager.h"
#import "APIClient+Pokemon.h"
#import "LocationManagerReactify.h"
#import "Pokemon.h"
#import <INTULocationManager/INTULocationManager.h>
#import <BlocksKit.h>

@implementation PokemonManager

+ (RACSignal *)getPokemonList
{
    return [[LocationManagerReactify currentLocationSignal] flattenMap:^RACStream *(CLLocation *location) {
        return [[[APIClient sharedClient] getPokemonListWithLat:[NSString stringWithFormat:@"%f",location.coordinate.latitude] Lng:[NSString stringWithFormat:@"%f",location.coordinate.longitude]] map:^id(RACTuple *tuple) {
            return [(NSArray *)tuple.first[@"pokemon"] bk_map:^id(NSDictionary *obj) {
                return [[Pokemon alloc] initWithData:obj];
            }];
        }];
    }];
}

@end
