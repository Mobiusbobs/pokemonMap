//
//  APIClient+Pokemon.m
//  PokemonMap
//
//  Created by LinYiting on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "APIClient+Pokemon.h"



@implementation APIClient (Pokemon)

- (RACSignal *)getPokemonListWithLat:(CGFloat)lat
                                 Lng:(CGFloat)lng
{
    
    return [self rac_GET:[NSString stringWithFormat:@"/api/pokemon.php?bounds=%f,%f,%f,%f",lat-0.01,lng-0.01,lat+0.01,lng+0.01] parameters:nil];
    
}

@end
