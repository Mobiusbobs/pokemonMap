//
//  Pokemon.m
//  PokemonMap
//
//  Created by LinYiting on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "Pokemon.h"

@implementation Pokemon

- (instancetype)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    self.uniqueId = data[@"id"];
    self.expirationTime = [NSDate dateWithTimeIntervalSince1970:[data[@"expiration_time"] doubleValue]];
    self.pokemonId = data[@"pokemonId"];
    self.lat = [data[@"latitude"] floatValue];
    self.lng = [data[@"longitude"] floatValue];
    
    return self;
}

@end
