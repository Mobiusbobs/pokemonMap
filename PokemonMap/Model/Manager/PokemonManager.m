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

@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@property (nonatomic, strong, readwrite) NSArray *pokemonList;
@property (nonatomic, strong, readonly) RACSubject *reloadTrigger;

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
    @weakify(self);
    
    [[LocationManagerReactify currentLocationSignal]
     subscribeNext:^(CLLocation *location) {
        @strongify(self);
        self.currentLocation = location;
    } error:^(NSError *error) {
        [AlertView showError:error withTitle:@"Error"];
    }];
}

- (RACSignal *)getPokemonListWithLocation:(CLLocation *)location
{
    CGFloat latitude = location.coordinate.latitude;
    CGFloat longitude = location.coordinate.longitude;
    
    return [[[APIClient sharedClient] getPokemonListWithLat:[NSString stringWithFormat:@"%f",latitude]
                                                        Lng:[NSString stringWithFormat:@"%f",longitude]]
            map:^id(RACTuple *tuple) {
                return [(NSArray *)tuple.first[@"pokemon"] bk_map:^id(NSDictionary *obj) {
                    return [[Pokemon alloc] initWithData:obj];
                }];
            }];
}

- (RACDisposable *)reloadPokemonList
{
    @weakify(self);
    return [[self getPokemonListWithLocation:self.currentLocation]
            subscribeNext:^(NSArray *array) {
                @strongify(self);
                self.pokemonList = array;
            } error:^(NSError *error) {
                [AlertView showError:error withTitle:@"Error"];
            }];
}

- (CLLocation *)currentLocation
{
    if (!_currentLocation) {
        _currentLocation = [[CLLocation alloc] initWithLatitude:37.787359 longitude:-122.408227];
    }
    return _currentLocation;
}
@end
