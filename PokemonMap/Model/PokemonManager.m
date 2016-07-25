//
//  PokemonManager.m
//  PokemonMap
//
//  Created by LinYiting on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "PokemonManager.h"
#import "APIClient+Pokemon.h"
#import "LocationManagerReactify.h"
#import "Pokemon.h"

#import <INTULocationManager/INTULocationManager.h>
#import <BlocksKit.h>

#import "AlertView.h"

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
    
    RAC(self, pokemonList) = [self.reloadTrigger flattenMap:^RACStream *(id value) {
        @strongify(self);
        return [self getPokemonList];
    }];
}

- (RACSignal *)getPokemonList
{
    CGFloat latitude = self.currentLocation.coordinate.latitude;
    CGFloat longitude = self.currentLocation.coordinate.longitude;
    
    return [[[APIClient sharedClient] getPokemonListWithLat:[NSString stringWithFormat:@"%f",latitude]
                                                        Lng:[NSString stringWithFormat:@"%f",longitude]]
            map:^id(RACTuple *tuple) {
                return [(NSArray *)tuple.first[@"pokemon"] bk_map:^id(NSDictionary *obj) {
                    return [[Pokemon alloc] initWithData:obj];
                }];
            }];
}

- (RACSubject *)reloadTrigger
{
    if (!_reloadTrigger) {
        _reloadTrigger = [RACSubject subject];
    }
    
    return _reloadTrigger;
}

- (void)reloadPokemonList
{
    [self.reloadTrigger sendNext:@1];
}
@end
