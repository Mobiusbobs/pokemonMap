//
//  MapViewController.m
//  PokemonMap
//
//  Created by ringtdblai on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "MapViewController.h"

// Third Party
#import <GoogleMaps/GoogleMaps.h>
#import <BlocksKit.h>

// Model
#import "PokemonManager.h"
#import "Pokemon.h"

#import "PokemonMarker.h"


@interface MapViewController ()

@property (nonatomic, weak) GMSMapView *mapView;

@property (nonatomic, strong) PokemonManager *manager;
@property (nonatomic, strong) NSArray *pokemonMarkers;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupMapView];
    [self bindManager];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.manager reloadPokemonList];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Serup UI
- (void)setupMapView
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    [self.view addSubview:mapView];
    
    mapView.myLocationEnabled = YES;
    self.mapView = mapView;
}

#pragma mark - Binding
- (void)bindManager
{
    self.manager = [PokemonManager sharedManager];
    
    @weakify(self);
    [[RACObserve(self.manager, currentLocation) ignore:nil]
     subscribeNext:^(CLLocation *currentLocation) {
         @strongify(self);
         
         GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
                                                                 longitude:currentLocation.coordinate.longitude
                                                                      zoom:6];
         self.mapView.camera = camera;
    }];
    
    [[RACObserve(self.manager, pokemonList) ignore:nil]
     subscribeNext:^(NSArray *pokemons) {
        @strongify(self);
         if (self.pokemonMarkers) {
             [self.pokemonMarkers bk_each:^(PokemonMarker *marker) {
                 marker.map = nil;
             }];
         }
         
         self.pokemonMarkers = [[pokemons bk_select:^BOOL(Pokemon *pokemon) {
             return pokemon && [pokemon isKindOfClass:[Pokemon class]];
         }] bk_map:^id(Pokemon *pokemon) {
             @strongify(self);
             PokemonMarker *marker = [[PokemonMarker alloc] initWithPokemon:pokemon];
             marker.map = self.mapView;
             return marker;
         }];
    }];
    
    
}
@end
