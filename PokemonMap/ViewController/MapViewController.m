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
#import <LCBannerView.h>

// Model
#import "PokemonManager.h"
#import "Pokemon.h"

#import "PokemonMarker.h"


@interface MapViewController ()
<LCBannerViewDelegate>

@property (nonatomic, weak) GMSMapView *mapView;

@property (nonatomic, strong) PokemonManager *manager;
@property (nonatomic, strong) NSArray *pokemonMarkers;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"PokemonMap";
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
    
    [self.manager reloadPokemonList];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Serup UI
- (void)setupNavBar
{    
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
                                                                 zoom:18];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-120) camera:camera];
    [self.view addSubview:mapView];
    
    mapView.myLocationEnabled = YES;
    self.mapView = mapView;
}

- (void)setupBanner
{
    LCBannerView *bannerView = [[LCBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 120, [UIScreen mainScreen].bounds.size.width, 120)
                                                          delegate:self
                                                         imageName:@"banner"
                                                             count:3
                                                      timeInterval:3.0f
                                     currentPageIndicatorTintColor:[UIColor orangeColor]
                                            pageIndicatorTintColor:[UIColor whiteColor]];
    
    [self.view addSubview:bannerView];
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
                                                                      zoom:18];
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

- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    
    NSLog(@"You clicked image in %@ at index: %ld", bannerView, (long)index);
    [self.manager reloadPokemonList];
}

- (void)settingButtonClicked:(id)sender
{
    SettingViewController *vc = [SettingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
