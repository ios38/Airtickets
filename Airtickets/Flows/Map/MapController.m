//
//  MapController.m
//  Airtickets
//
//  Created by Maksim Romanov on 11.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "MapController.h"
#import "DataManager.h"
#import "MRCountry.h"
#import "MRCity.h"
#import "MRAirport.h"
#import "LocationService.h"
#import "AirportAnnotationView.h"
#import "AirportCalloutView.h"
#import "UserSession.h"

#define MAS_SHORTHAND
#import "Masonry.h"

@interface MapController ()

@property (strong,nonatomic) NSArray *airports;
@property (strong,nonatomic) NSArray *airportsInRegion;
@property (strong,nonatomic) NSMutableArray *annotations;
@property (strong,nonatomic) MKMapView *mapView;
@property (strong,nonatomic) UIButton *myLocationButton;
@property (strong,nonatomic) LocationService *locationService;
@property (strong,nonatomic) CLLocation *currentLocation;

@end

@implementation MapController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    self.navigationController.navigationBar.hidden = YES;
    self.locationService = [[LocationService alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationWasUpdated:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
        
    self.mapView = MKMapView.new;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(self.view);
        make.top.equalTo(self.view.topMargin);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottomMargin);
    }];

    self.myLocationButton = UIButton.new;
    [self.myLocationButton setImage:[UIImage systemImageNamed:@"location.fill"] forState:UIControlStateNormal];
    self.myLocationButton.tintColor = [UIColor whiteColor];
    self.myLocationButton.layer.cornerRadius = 10;
    self.myLocationButton.backgroundColor = [UIColor grayColor];
    [self.myLocationButton addTarget:self action:@selector(showMyLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:self.myLocationButton];
    [self.myLocationButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mapView).with.inset(30);
        make.right.equalTo(self.mapView).with.inset(10);
        make.width.height.mas_equalTo(30);
    }];

    self.airports = DataManager.shared.airports;
    self.annotations = NSMutableArray.new;
}

- (void)locationWasUpdated:(NSNotification*)notification {
    CLLocation *location = notification.object;
    self.currentLocation = location;
    CLLocationCoordinate2D coordinate = location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 100000, 100000);
    [self.mapView setRegion: region animated: YES];

    MKUserLocation *annotation = MKUserLocation.new;
    annotation.coordinate = coordinate;
    [self.mapView addAnnotation:annotation];

}

- (void)showMyLocation {
    CLLocationCoordinate2D coordinate = self.currentLocation.coordinate;
    [self.mapView setCenterCoordinate:coordinate animated:YES];
}


- (NSMutableArray *)airportsFilteredWith:(NSString *)countryCode {
    NSMutableArray *airports = NSMutableArray.new;
    for (MRAirport *airport in DataManager.shared.airports) {
        if (airport.countryCode == countryCode &&
            ![airport.name containsString:@"Rail"] &&
            ![airport.name containsString:@"Bus"]) {
            //NSLog(@"%@,%@,%@",airport.name,cityCode,countryCode);
            [airports addObject:airport];
        }
    }
    return airports;
}

- (NSMutableArray *)airportsInRegion:(MKCoordinateRegion) region {
    NSMutableArray *airports = NSMutableArray.new;
    for (MRAirport *airport in self.airports) {
        //NSLog(@"%@,%f,%f",airport.name,airport.coordinate.latitude,airport.coordinate.longitude);
        CLLocation *airportLocation = [[CLLocation alloc] initWithLatitude:airport.coordinate.latitude longitude:airport.coordinate.longitude];
        if ([self region:region containsLocation:airportLocation]) {
            [airports addObject:airport];
        }
    }
    return airports;
}

- (NSMutableArray *)annotationsFromAirports:(NSArray *)airports {
    NSMutableArray *annotations = NSMutableArray.new;
    for (MRAirport *airport in airports) {
        MKPointAnnotation *annotation = MKPointAnnotation.new;
        annotation.title = [self cityWithCityCode:airport.cityCode];
        annotation.subtitle = airport.name;
        annotation.coordinate = airport.coordinate;
        
        [annotations addObject:annotation];
    }
    return annotations;
}
         
- (NSString *)cityWithCityCode:(NSString *)cityCode {
    for (MRCity *city in DataManager.shared.cities) {
        if (city.code == cityCode) {
            return city.name;
            break;
        }
    }
    return @"";
}

- (NSMutableArray *)annotationToRemoveWithRegion:(MKCoordinateRegion) region {
    NSMutableArray *annotationsToRemove = NSMutableArray.new;
    for (MKPointAnnotation *annotation in self.annotations) {
        CLLocation *annotationLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
        if (![self region:region containsLocation:annotationLocation]) {
            [annotationsToRemove addObject:annotation];
        }
    }
    return annotationsToRemove;
}

- (CLLocationDegrees)standardAngle:(CLLocationDegrees)angle {
    //angle %= 360;
    return angle < -180 ? -360 - angle : angle > 180 ? 360 - 180 : angle;
}

- (BOOL)region:(MKCoordinateRegion)region containsLocation:(CLLocation*)location {
    CLLocationDegrees deltaLat = fabs([self standardAngle:(region.center.latitude - location.coordinate.latitude)]);
    CLLocationDegrees deltalong = fabs([self standardAngle:(region.center.longitude - location.coordinate.longitude)]);
    return region.span.latitudeDelta >= deltaLat && region.span.longitudeDelta >= deltalong;
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"MarkerIdentifier";
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    } else {
        AirportAnnotationView *annotationView = (AirportAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView) {
            annotationView = [[AirportAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    //NSLog(@"didSelectAnnotationView with title: %@",view.annotation.title);
    if (![view.annotation isKindOfClass:[MKUserLocation class]]){
        
        AirportCalloutView *airportCalloutView = [[AirportCalloutView alloc] initWithAnnotation:view.annotation];
        airportCalloutView.center = CGPointMake(view.bounds.size.width / 2, -airportCalloutView.bounds.size.height*0.6);
        [airportCalloutView.selectButton addTarget:self action:@selector(selectButtonTappedWith:) forControlEvents:UIControlEventTouchUpInside];

        [view addSubview:airportCalloutView];
        [self.mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    }
}

- (void) selectButtonTappedWith:(UIButton *)sender {
    AirportCalloutView *view = (AirportCalloutView *)sender.superview;
    //NSLog(@"Selected Airport: %@",view.annotation.subtitle);
    NSString *airport = view.annotation.subtitle;
    [view removeFromSuperview];
    NSLog(@"Selected Airport: %@",airport);
    UserSession.shared.departureAirport = airport;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    //NSLog(@"didDeselectAnnotationView with title: %@",view.annotation.title);
    if ([view isKindOfClass:[AirportAnnotationView class]]) {
        for (AirportCalloutView *subview in view.subviews) {
            if ([subview isKindOfClass:[AirportCalloutView class]]) {
                [subview removeFromSuperview];
            }
        }
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //NSLog(@"region span: %f,%f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);

    if (mapView.region.span.latitudeDelta < 40 && mapView.region.span.longitudeDelta < 40) {
    //dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    //dispatch_async(queue, ^{
    NSArray *newAirports = NSArray.new;
    NSArray *airportsToAdd = NSArray.new;
    NSArray *annotationsToAdd = NSArray.new;
    NSArray *annotationsToRemove = NSArray.new;
    
    //MKMapRect mapRect = mapView.visibleMapRect;
    //MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    MKCoordinateRegion region = mapView.region;
    newAirports = [self airportsInRegion:region];

    NSPredicate *airportsToAddPredicate = [NSPredicate predicateWithBlock:
        ^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [self.airportsInRegion containsObject:evaluatedObject] ? NO : YES;
    }];

    airportsToAdd = [newAirports filteredArrayUsingPredicate:airportsToAddPredicate];
    //NSLog(@"airportsToAdd count: %lu",(unsigned long)[airportsToAdd count]);
    
    self.airportsInRegion = newAirports;
    //NSLog(@"airportsInRegion count: %lu",(unsigned long)[self.airportsInRegion count]);

    if (airportsToAdd > 0) {
        annotationsToAdd = [self annotationsFromAirports:airportsToAdd];
        //NSLog(@"annotationsToAdd count: %lu",(unsigned long)[annotationsToAdd count]);
        [self.annotations addObjectsFromArray:annotationsToAdd];
        [self.mapView addAnnotations:annotationsToAdd];
    }
    
    annotationsToRemove = [self annotationToRemoveWithRegion:region];
    [self.annotations removeObjectsInArray:annotationsToRemove];
    [self.mapView removeAnnotations:annotationsToRemove];

    //NSLog(@"self annotations count: %lu",(unsigned long)[self.annotations count]);
    NSLog(@"mapView annotations count: %lu",(unsigned long)[self.mapView.annotations count]);
    //NSMutableString *annotations = NSMutableString.new;
    //for (MKPointAnnotation *annotation in self.annotations) {
    //    [annotations appendFormat:@"%@ ",annotation.title];
    //}
    //NSLog(@"%@ ",annotations);
    //});
    } else {
        self.airportsInRegion = @[];
        [self.mapView removeAnnotations:self.annotations];
        [self.annotations removeAllObjects];
    }
}

- (void)mapViewDidChangeVisibleRegion:(MKMapView *)mapView {
    
}

@end
