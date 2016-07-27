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
#import <INTULocationManager.h>
#import <MBProgressHUD.h>
#import <Masonry.h>
#import "KLCPopup.h"

// Model
#import "PokemonManager.h"
#import "Pokemon.h"

#import "PokemonMarker.h"
#import "GAWrapper.h"


@interface MapViewController ()
<
    GMSMapViewDelegate,
    SDCycleScrollViewDelegate
>

@property (nonatomic, weak) GMSMapView *mapView;

@property (nonatomic, strong) PokemonManager *manager;

@property (nonatomic, strong) NSMutableArray *pokemonMarkers;

@property (nonatomic, strong) GMSMarker *centerMarker;

@property (nonatomic, assign) int bannerHeight;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"Pokemon Map", nil);
    self.pokemonMarkers = [NSMutableArray array];
    
    self.bannerHeight = floorf(90.0f*self.view.frame.size.width/728.0f);
    
    [self setupNavBar];
    [self setupMapView];
    [self setupBanner];
    [self bindManager];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self requestCurrentLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    
    UIBarButtonItem *questionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"question"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(showTutorial)];
    self.navigationItem.leftBarButtonItem = questionButton;
    
    
}

- (void)setupMapView
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.778704
                                                            longitude:-122.389520
                                                                 zoom:14];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.bannerHeight-64) camera:camera];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    mapView.myLocationEnabled = YES;
    mapView.settings.myLocationButton = YES;
    self.mapView = mapView;
    
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reloadButton setImage:[UIImage imageNamed:@"reload"] forState:UIControlStateNormal];
    [reloadButton addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:reloadButton];
    
    [reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.bottom.equalTo(self.mapView).with.offset(-35);
        make.left.equalTo(self.mapView).with.offset(15);
    }];
    
}

- (void)setupBanner
{
    
    UIImage *image1 = [UIImage imageNamed:NSLocalizedString(@"ad1", nil)];
    UIImage *image2 = [UIImage imageNamed:NSLocalizedString(@"ad2", nil)];
    UIImage *image3 = [UIImage imageNamed:NSLocalizedString(@"ad3", nil)];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, self.view.frame.size.height - self.bannerHeight -64, [UIScreen mainScreen].bounds.size.width, self.bannerHeight) imageNamesGroup:@[image1,image2,image3]];
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    cycleScrollView.showPageControl = NO;
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
         if ([self.pokemonMarkers count] > 0) {
             [[self.pokemonMarkers bk_select:^BOOL(PokemonMarker *marker) {
                 return !marker.pokemon;
             }] bk_each:^(PokemonMarker *marker) {
                 marker.map = nil;
             }];
         }
         NSArray *newPokemons =
         [pokemons bk_select:^BOOL(Pokemon *pokemon) {
             @strongify(self);
             return ![self.pokemonMarkers bk_any:^BOOL(PokemonMarker *marker) {
                 return (marker.pokemon == pokemon);
             }];
         }];
         
         [newPokemons bk_each:^(Pokemon *pokemon) {
             @strongify(self);
             
             PokemonMarker *marker = [[PokemonMarker alloc] initWithPokemon:pokemon];
             marker.map = self.mapView;
             [self.pokemonMarkers addObject:marker];
         }];
         
    }];
}

#pragma mark - Getter
- (GMSMarker *)centerMarker
{
    if (!_centerMarker) {
        _centerMarker = [[GMSMarker alloc] init];
        _centerMarker.icon = [UIImage imageNamed:@"radar"];
        _centerMarker.map = self.mapView;
    }
    return _centerMarker;
}

#pragma mark - Private method
- (void)requestCurrentLocation
{
    @weakify(self);
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyRoom
                                       timeout:5.0
                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                         block:^(CLLocation *currentLocation,
                                                 INTULocationAccuracy achievedAccuracy,
                                                 INTULocationStatus status)
     {
         @strongify(self);
         [self updateCenterMarkerWithLocation:currentLocation];
     }];
}

- (void)updateCenterMarkerWithLocation:(CLLocation *)location
{
    self.manager.currentLocation = location;
    
    [self.manager reloadPokemonListWithLocation:location];
    
    self.centerMarker.position = location.coordinate;
    
    [self.mapView animateToLocation:location.coordinate];
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [GAWrapper sendReport:@"Publish Post" andProperty:@""];
    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude];
    
    [self updateCenterMarkerWithLocation:centerLocation];

}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [GAWrapper sendReport:@"Play Video" andProperty:@""];
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

- (void)reloadData
{
    [GAWrapper sendReport:@"Publish Post" andProperty:@""];
    [self.manager reloadPokemonListWithLocation:self.manager.currentLocation];
}

- (void)showTutorial
{
    UIView* contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width - 100, 250);
    contentView.layer.cornerRadius = 10;
    contentView.clipsToBounds = YES;
    
    UIImageView *iconImage = [UIImageView new];
    iconImage.image = [UIImage imageNamed:@"icon"];
    [contentView addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
        make.top.equalTo(contentView).with.offset(10);
        make.centerX.equalTo(contentView);
    }];
    
    UILabel *label1 = [UILabel new];
    label1.font = [UIFont systemFontOfSize:16];
    label1.numberOfLines = 0;
    
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Tutorial1", nil)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, NSLocalizedString(@"Tutorial1", nil).length)];
    
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blackColor]
                       range:NSMakeRange(0, NSLocalizedString(@"Tutorial1", nil).length)];
    
    [attrString addAttribute:NSKernAttributeName
                       value:@(1.2)
                       range:NSMakeRange(0, NSLocalizedString(@"Tutorial1", nil).length)];
    label1.attributedText = attrString;
    [contentView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).with.offset(16);
        make.right.equalTo(contentView).with.offset(-16);
        make.top.equalTo(iconImage.mas_bottom).with.offset(16);
    }];
    
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView];
    [popup show];
}

@end
