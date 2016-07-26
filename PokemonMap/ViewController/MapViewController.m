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
<
    GMSMapViewDelegate
>

@property (nonatomic, weak) GMSMapView *mapView;

@property (nonatomic, strong) PokemonManager *manager;

@property (nonatomic, strong) NSMutableSet *pokemons;
@property (nonatomic, strong) NSArray *pokemonMarkers;

@property (nonatomic, strong) GMSMarker *centerMarker;
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
//    [self.manager reloadPokemonList];
    
   
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
                                                                 zoom:15];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    mapView.myLocationEnabled = YES;
    mapView.settings.myLocationButton = YES;
    self.mapView = mapView;
}

#pragma mark - Binding
- (void)bindManager
{
    self.manager = [PokemonManager sharedManager];
    
    @weakify(self);
    
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

- (GMSMarker *)centerMarker
{
    if (!_centerMarker) {
        _centerMarker = [[GMSMarker alloc] init];
        _centerMarker.map = self.mapView;
    }
    return _centerMarker;
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.manager.currentLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                              longitude:coordinate.longitude];
    
    [self.manager reloadPokemonListWithLocation:self.manager.currentLocation];
    
    self.centerMarker.position = coordinate;
    
    [self.mapView animateToLocation:coordinate];

}

@end
