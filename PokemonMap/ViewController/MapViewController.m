//
//  MapViewController.m
//  PokemonMap
//
//  Created by ringtdblai on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "MapViewController.h"
#import "SettingViewController.h"
// Third Party
#import <GoogleMaps/GoogleMaps.h>
#import <BlocksKit.h>
#import <SDCycleScrollView.h>

// Model
#import "PokemonManager.h"
#import "Pokemon.h"

#import "PokemonMarker.h"


@interface MapViewController ()
<
    GMSMapViewDelegate,
SDCycleScrollViewDelegate
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"Pokemon Map", nil);
    [self setupNavBar];
    [self setupMapView];
    [self setupBanner];
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
- (void)setupNavBar
{
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIBarButtonItem *imagetestButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(settingButtonClicked:)];
    self.navigationItem.rightBarButtonItem = imagetestButton;
}

- (void)setupMapView
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:14];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-120) camera:camera];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    mapView.myLocationEnabled = YES;
    mapView.settings.myLocationButton = YES;
    self.mapView = mapView;
}

- (void)setupBanner
{
    
    UIImage *image1 = [UIImage imageNamed:NSLocalizedString(@"ad1", nil)];
    UIImage *image2 = [UIImage imageNamed:NSLocalizedString(@"ad2", nil)];
    UIImage *image3 = [UIImage imageNamed:NSLocalizedString(@"ad3", nil)];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, self.view.frame.size.height - 120, [UIScreen mainScreen].bounds.size.width, 120) imageNamesGroup:@[image1,image2,image3]];
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    cycleScrollView.delegate = self;
    
    
    
    [self.view addSubview:cycleScrollView];
}

#pragma mark - Binding
- (void)bindManager
{
    self.manager = [PokemonManager sharedManager];
    self.manager.errorVc = self;
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
        _centerMarker.icon = [UIImage imageNamed:@"radar"];
        _centerMarker.map = self.mapView;
    }
    return _centerMarker;
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.manager.currentLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                              longitude:coordinate.longitude];
    
    [self.manager reloadPokemonListWithLocation:self.manager.currentLocation];
    
    self.centerMarker.position = coordinate;
    
    [self.mapView animateToLocation:coordinate];

}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://taps.io/Bboowji2"]];
}

- (void)settingButtonClicked:(id)sender
{
    SettingViewController *vc = [SettingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
