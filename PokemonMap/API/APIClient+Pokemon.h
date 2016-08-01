//
//  APIClient+Pokemon.h
//  PokemonMap
//
//  Created by LinYiting on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "APIClient.h"
#import <GoogleMaps/GoogleMaps.h>

#define API_GET_POKEMON_PATH(lat,lng) [NSString stringWithFormat:@"/map/data/%@/%@",lat,lng]


@interface APIClient (Pokemon)

- (RACSignal *)getPokemonListWithLat:(CGFloat)lat
                                 Lng:(CGFloat)lng;

- (RACSignal *)getPokemonListWithBounds:(GMSCoordinateBounds *)bounds;

@end
