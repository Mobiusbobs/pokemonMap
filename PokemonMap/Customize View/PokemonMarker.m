//
//  PokemonMarker.m
//  PokemonMap
//
//  Created by ringtdblai on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "PokemonMarker.h"
#import <ReactiveCocoa.h>

@interface PokemonMarker ()

@property (nonatomic, weak, readwrite) Pokemon *pokemon;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PokemonMarker

- (instancetype)initWithPokemon:(Pokemon *)pokemon
{
    self = [super init];
    
    if (self) {
        self.pokemon = pokemon;
    }
    return self;
}

- (void)setPokemon:(Pokemon *)pokemon
{
    _pokemon = pokemon;
    
    
    self.title =  NSLocalizedString(pokemon.pokemonId, nil);
    self.position = CLLocationCoordinate2DMake(pokemon.lat, pokemon.lng);
    self.icon = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", pokemon.pokemonId]];
    
    [self updateExpireTime];
    
}

- (void)updateExpireTime
{
    NSDate *expirationTime = self.pokemon.expirationTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    self.snippet = [NSString stringWithFormat:@"Expire Time:%@",[formatter stringFromDate:expirationTime]];
}

@end
