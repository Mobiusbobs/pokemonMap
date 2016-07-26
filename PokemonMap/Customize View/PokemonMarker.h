//
//  PokemonMarker.h
//  PokemonMap
//
//  Created by ringtdblai on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

#import "Pokemon.h"

@interface PokemonMarker : GMSMarker

@property (nonatomic, weak, readonly) Pokemon *pokemon;

- (instancetype)initWithPokemon:(Pokemon *)pokemon;
- (void)updateExpireTime;

@end
