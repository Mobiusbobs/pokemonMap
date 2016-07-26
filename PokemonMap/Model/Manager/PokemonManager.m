//
//  PokemonManager.m
//  PokemonMap
//
//  Created by LinYiting on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "PokemonManager.h"
// Third Party
#import <INTULocationManager/INTULocationManager.h>
#import <BlocksKit.h>

// Model
#import "Pokemon.h"

// Other
#import "AlertView.h"
#import "APIClient+Pokemon.h"
#import "LocationManagerReactify.h"



@interface PokemonManager ()

@property (nonatomic, strong, readwrite) NSArray *pokemonList;
@property (nonatomic, strong, readonly) RACSubject *reloadTrigger;
@property (nonatomic, strong) NSMutableDictionary *pokemonDict;

@end

@implementation PokemonManager
@synthesize reloadTrigger = _reloadTrigger;

+ (instancetype)sharedManager
{
    static PokemonManager *manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[PokemonManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
//    @weakify(self);
    
    self.pokemonDict = [NSMutableDictionary dictionary];
    
//    [[LocationManagerReactify getCurrentLocationSignal]
//     subscribeNext:^(CLLocation *location) {
//        @strongify(self);
//        self.currentLocation = location;
//    } error:^(NSError *error) {
//        [AlertView showError:error withTitle:@"Error"];
//    }];
    
//    [[[[RACObserve(self, currentLocation) ignore:nil]
//      flattenMap:^RACStream *(CLLocation *location) {
//          @strongify(self);
//          return [[[APIClient sharedClient] getPokemonListWithLat:[NSString stringWithFormat:@"%f",location.coordinate.latitude]
//                                                              Lng:[NSString stringWithFormat:@"%f",location.coordinate.longitude]]
//                  map:^id(RACTuple *tuple) {
//                      @strongify(self);
//                      NSArray *dataArray = tuple.first[@"pokemon"];
//                      return [self mappingPokemonArray:dataArray];
//                  }];
//      }] combineLatestWith:self.reloadTrigger]
//     subscribeNext:^(RACTuple *tuple) {
//          @strongify(self);
//          self.pokemonList = tuple.first;
//      }];
}

- (NSArray *)mappingPokemonArray:(NSArray *)dataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for(NSDictionary *dict in dataArray)
    {
        NSString *uniqueId = [dict[@"id"] stringValue];
        Pokemon *pokemon = self.pokemonDict[uniqueId];
        if(pokemon){
            [pokemon updateWithData:dict];
        } else {
            pokemon = [[Pokemon alloc] initWithData:dict];
            [self.pokemonDict setObject:pokemon forKey:uniqueId];
        }
        [array addObject:pokemon];
    }
    
    return [self.pokemonDict allValues];
}

- (CLLocation *)currentLocation
{
    if (!_currentLocation) {
        _currentLocation = [[CLLocation alloc] initWithLatitude:37.787359 longitude:-122.408227];
    }
    return _currentLocation;
}

- (RACSubject *)reloadTrigger
{
    if (!_reloadTrigger) {
        _reloadTrigger = [RACSubject subject];
    }
    
    return _reloadTrigger;
}

- (void)reload
{
    [self.reloadTrigger sendNext:@YES];
}

- (RACDisposable *)reloadPokemonListWithLocation:(CLLocation *)location
{
    @weakify(self);
    return [[[[APIClient sharedClient] getPokemonListWithLat:location.coordinate.latitude
                                                         Lng:location.coordinate.longitude]
             map:^id(RACTuple *tuple) {
                 @strongify(self);
                 NSArray *dataArray = tuple.first[@"pokemon"];
                 return [self mappingPokemonArray:dataArray];
             }] subscribeNext:^(NSArray *array) {
                 @strongify(self);
                 self.pokemonList = array;
             }];
}

//- (RACSignal *)getPokemonListWithLocation:(CLLocation *)location
//{
//    CGFloat latitude = location.coordinate.latitude;
//    CGFloat longitude = location.coordinate.longitude;
//    
//    @weakify(self);
//    return [[[APIClient sharedClient] getPokemonListWithLat:[NSString stringWithFormat:@"%f",location.coordinate.latitude]
//                                                        Lng:[NSString stringWithFormat:@"%f",location.coordinate.longitude]]
//            map:^id(RACTuple *tuple) {
//                @strongify(self);
//                NSArray *dataArray = tuple.first[@"pokemon"];
//                return [self mappingPokemonArray:dataArray];
//            }];
//}
@end
