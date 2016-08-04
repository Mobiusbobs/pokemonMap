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
    https://map_api.goradar.io/raw_data?pokemon=true&pokestops=true&gyms=false&scanned=false&swLat=34.01036035697912&swLng=-118.51064721438598&neLat=34.01422005832671&neLng=-118.48399678561401
    return [self rac_GET:[NSString stringWithFormat:@"/raw_data?pokemon=true&pokestops=false&gyms=false&scanned=false&swLat=%f&swLng=%f&neLat=%f&neLng=%f",lat-0.02,lng-0.02,lat+0.02,lng+0.02] parameters:nil];
    
}

- (RACSignal *)getPokemonListWithBounds:(GMSCoordinateBounds *)bounds
{    
    NSString *apiString = [NSString stringWithFormat:@"/raw_data?pokemon=true&pokestops=false&gyms=false&scanned=false&swLat=%f&swLng=%f&neLat=%f&neLng=%f",bounds.southWest.latitude,bounds.southWest.longitude,bounds.northEast.latitude,bounds.northEast.longitude];
    
    return [self rac_GET:apiString parameters:nil];
    
}
@end
