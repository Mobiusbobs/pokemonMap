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
    
    [self updateWithData:data];
    
    return self;
}

- (void)updateWithData:(NSDictionary *)data
{
    self.uniqueId = data[@"encounter_id"];
   
    NSTimeInterval timeInterval = (long)[data[@"disappear_time"] longValue] / 1000;
    self.expirationTime = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    self.pokemonId = [data[@"pokemon_id"] stringValue];
    self.lat = [data[@"latitude"] floatValue];
    self.lng = [data[@"longitude"] floatValue];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[Pokemon class]]) {
        Pokemon *pm = (Pokemon *)object;
        return [pm.uniqueId isEqualToString:self.uniqueId];
    }
    return NO;
}

@end
