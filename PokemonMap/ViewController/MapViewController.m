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

#import "PokemonManager.h"



@interface MapViewController ()

@property (nonatomic, weak) GMSMapView *mapView;

@property (nonatomic, strong) PokemonManager *manager ;

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
    
    
    
    
}
@end
