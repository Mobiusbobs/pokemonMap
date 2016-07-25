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

@property (nonatomic, weak)GMSMapView *mapView;


@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupMapView];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[PokemonManager getPokemonList] subscribeNext:^(id x) {
        NSLog(@"x:%@",x);
    }];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

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
@end
