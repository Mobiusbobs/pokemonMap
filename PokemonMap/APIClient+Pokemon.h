//
//  APIClient+Pokemon.h
//  PokemonMap
//
//  Created by LinYiting on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "APIClient.h"
@interface APIClient (Pokemon)

- (RACSignal *)getPokemonListWithLat:(NSString *)lat
                                 Lng:(NSString *)lng;


@end
