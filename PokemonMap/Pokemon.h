//
//  Pokemon.h
//  PokemonMap
//
//  Created by LinYiting on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pokemon : NSObject

@property (nonatomic, strong) NSString *uniqueId;
@property (nonatomic, strong) NSDate *expirationTime;
@property (nonatomic, strong) NSString *pokemonId;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lng;

- (instancetype)initWithData:(NSDictionary *)data;

/*
"id": 68151055,
"data": "[]",
"expiration_time": 1469428519,
"pokemonId": 16,
"latitude": 37.791422423054,
"longitude": -122.43101986315,
"uid": "808580c6be7:16",
"is_alive": true
*/
@end
