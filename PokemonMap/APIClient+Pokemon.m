//
//  APIClient+Pokemon.m
//  PokemonMap
//
//  Created by LinYiting on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "APIClient+Pokemon.h"

@implementation APIClient (Pokemon)

- (RACSignal *)getPokemonListWithLat:(NSString *)lat
                                 Lng:(NSString *)lng
{
    
    return [self rac_GET:[NSString stringWithFormat:@"/data/%@/%@",lat,lng] parameters:nil];
}

@end
