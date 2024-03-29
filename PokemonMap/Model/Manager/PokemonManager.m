//
//  PokemonManager.m
//  PokemonMap
//
//  Created by LinYiting on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "PokemonManager.h"
#import "AppDelegate.h"

// Third Party
#import <INTULocationManager/INTULocationManager.h>
#import <BlocksKit.h>
#import <TSMessage.h>
#import <MBProgressHUD.h>

// Model
#import "Pokemon.h"

// Other
#import "AlertView.h"
#import "APIClient+Pokemon.h"
#import "LocationManagerReactify.h"



@interface PokemonManager ()

@property (nonatomic, strong, readwrite) NSArray *pokemonList;
@property (nonatomic, strong) NSMutableDictionary *pokemonDict;

@property (nonatomic, strong) NSArray *blockedArray;
@property (nonatomic, strong) NSTimer *checkTimer;

@end

@implementation PokemonManager

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
    RACSignal *blockedSignal = [[[NSUserDefaults standardUserDefaults] rac_channelTerminalForKey:@"pokemon_blacklist"] distinctUntilChanged];
    
    RAC(self,blockedArray) = blockedSignal;
    
    self.checkTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(updateList)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (NSArray *)mappingPokemonArray:(NSArray *)dataArray
{
    NSMutableArray *array = [NSMutableArray array];
    for(NSDictionary *dict in dataArray)
    {
        NSString *uniqueId = dict[@"id"];
        Pokemon *pokemon = self.pokemonDict[uniqueId];
        if(pokemon){
            [pokemon updateWithData:dict];
        } else {
            pokemon = [[Pokemon alloc] initWithData:dict];
            [self.pokemonDict setObject:pokemon forKey:uniqueId];
        }
        [array addObject:pokemon];
    }
    
    return [array bk_reject:^BOOL(Pokemon *obj) {
        return [self.blockedArray bk_any:^BOOL(NSString *blockId) {
            return [obj.pokemonId isEqualToString:blockId];
        }];
    }];
}

- (CLLocation *)currentLocation
{
    if (!_currentLocation) {
        _currentLocation = [[CLLocation alloc] initWithLatitude:37.787359 longitude:-122.408227];
    }
    
    return _currentLocation;
}

#pragma mark - Private Method
- (void)updateList
{
    if (!self.pokemonList || [self.pokemonList count] == 0) {
        return;
    }
    
    BOOL hasExpiredPokemon = [self.pokemonList bk_any:^BOOL(Pokemon * obj) {
        return [obj.expirationTime timeIntervalSinceNow] < 0;
    }];
    
    if (!hasExpiredPokemon) {
        return;
    }
    
    self.pokemonList = [self.pokemonList bk_reject:^BOOL(Pokemon *obj) {
        return [obj.expirationTime timeIntervalSinceNow] < 0;
    }];
    
    self.pokemonDict = [NSMutableDictionary dictionary];

    for (Pokemon *pokemon in self.pokemonList) {
        [self.pokemonDict setObject:pokemon forKey:pokemon.uniqueId];
    }
    
}

- (NSArray *)processPokemonData:(NSArray *)dataArray
{
    return dataArray;
}

#pragma mark - Public Method
- (RACDisposable *)reloadPokemonListWithLocation:(CLLocation *)location
{
    [MBProgressHUD showHUDAddedTo:self.errorVc.view animated:YES];
    @weakify(self);
    return [[[[APIClient sharedClient] getPokemonListWithLat:location.coordinate.latitude
                                                         Lng:location.coordinate.longitude]
             map:^id(RACTuple *tuple) {
                 @strongify(self);
                 NSArray *dataArray = tuple.first[@"pokemons"];
                 NSArray *finalDataArray = [self processPokemonData:dataArray];
                 return [self mappingPokemonArray:finalDataArray];
             }] subscribeNext:^(NSArray *array) {
                 @strongify(self);
                 [MBProgressHUD hideAllHUDsForView:self.errorVc.view animated:YES];
                 self.pokemonList = array;
             } error:^(NSError *error) {
                 @strongify(self);
                 [MBProgressHUD hideAllHUDsForView:self.errorVc.view animated:YES];
                 [TSMessage showNotificationInViewController:self.errorVc
                                                       title:NSLocalizedString(@"Server Down Title", nil)
                                                    subtitle:NSLocalizedString(@"Server Down Subtitle", nil)
                                                       image:nil
                                                        type:TSMessageNotificationTypeError
                                                    duration:TSMessageNotificationDurationEndless
                                                    callback:nil
                                                 buttonTitle:nil
                                              buttonCallback:^{
                                                  NSLog(@"User tapped the button");
                                              }
                                                  atPosition:TSMessageNotificationPositionTop
                                        canBeDismissedByUser:YES];
                 
             }];
}

- (RACDisposable *)reloadPokemonListWithBounds:(GMSCoordinateBounds *)bounds
{
    [MBProgressHUD showHUDAddedTo:self.errorVc.view animated:YES];
    @weakify(self);
    return [[[[APIClient sharedClient] getPokemonListWithBounds:bounds]
             map:^id(RACTuple *tuple) {
                 @strongify(self);
                 NSArray *dataArray = tuple.first[@"pokemons"];
                 NSArray *finalDataArray = [self processPokemonData:dataArray];
                 return [self mappingPokemonArray:finalDataArray];
             }] subscribeNext:^(NSArray *array) {
                 @strongify(self);
                 [MBProgressHUD hideAllHUDsForView:self.errorVc.view animated:YES];
                 self.pokemonList = array;
             } error:^(NSError *error) {
                 @strongify(self);
                 [MBProgressHUD hideAllHUDsForView:self.errorVc.view animated:YES];
                 [TSMessage showNotificationInViewController:self.errorVc
                                                       title:NSLocalizedString(@"Server Down Title", nil)
                                                    subtitle:NSLocalizedString(@"Server Down Subtitle", nil)
                                                       image:nil
                                                        type:TSMessageNotificationTypeError
                                                    duration:TSMessageNotificationDurationEndless
                                                    callback:nil
                                                 buttonTitle:nil
                                              buttonCallback:^{
                                                  NSLog(@"User tapped the button");
                                              }
                                                  atPosition:TSMessageNotificationPositionTop
                                        canBeDismissedByUser:YES];
                 
             }];
}


@end
