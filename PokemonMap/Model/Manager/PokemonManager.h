//
//  PokemonManager.h
//  PokemonMap
//
//  Created by LinYiting on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>


@interface PokemonManager : NSObject

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) NSArray *pokemonList;

+ (instancetype)sharedManager;
- (RACDisposable *)reloadPokemonList;


@end