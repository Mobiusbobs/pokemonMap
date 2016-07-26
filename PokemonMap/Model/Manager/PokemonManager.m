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

@property (nonatomic, strong) NSArray *blockedArray;

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
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr subscribeToLocationUpdatesWithBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        @strongify(self);
        if (status == INTULocationStatusSuccess) {
            self.currentLocation = currentLocation;
        }
        else if (status == INTULocationStatusTimedOut) {
            [TSMessage showNotificationInViewController:self.errorVc
                                                  title:NSLocalizedString(@"GPS Title", nil)
                                               subtitle:NSLocalizedString(@"GPS Subtitle", nil)
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
        }
        else {
            [TSMessage showNotificationInViewController:self.errorVc
                                                  title:NSLocalizedString(@"GPS Title", nil)
                                               subtitle:NSLocalizedString(@"GPS Subtitle", nil)
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
        }
    }];

    
    RACSignal *blockedSignal = [[[NSUserDefaults standardUserDefaults] rac_channelTerminalForKey:@"pokemon_blacklist"] distinctUntilChanged];
    
    RAC(self,blockedArray) = blockedSignal;
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
                self.pokemonList = [array bk_reject:^BOOL(Pokemon *obj) {
                    return [self.blockedArray bk_any:^BOOL(NSString *blockId) {
                        return [obj.pokemonId isEqualToString:blockId];
                    }];
                }];
            } error:^(NSError *error) {
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

- (CLLocation *)currentLocation
{
    if (!_currentLocation) {
        _currentLocation = [[CLLocation alloc] initWithLatitude:37.787359 longitude:-122.408227];
    }
    
    return _currentLocation;
}
@end
