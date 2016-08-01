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
    
    return [self rac_GET:[NSString stringWithFormat:@"/api/pokemon.php?bounds=%f,%f,%f,%f",lat-0.02,lng-0.02,lat+0.02,lng+0.02] parameters:nil];
    
}

- (RACSignal *)getPokemonListWithBounds:(GMSCoordinateBounds *)bounds
{
    NSString *boundsString = [NSString stringWithFormat:@"%f,%f,%f,%f",
                              bounds.southWest.latitude,
                              bounds.southWest.longitude,
                              bounds.northEast.latitude,
                              bounds.northEast.longitude];
    
    NSDictionary *param = @{@"bounds":boundsString};
    
    return [self rac_GET:@"/api/pokemon.php" parameters:param];
    
}
@end
