//
//  MapController.m
//  Airtickets
//
//  Created by Maksim Romanov on 11.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "MapController.h"
#import "DataManager.h"
#import "Country.h"
#import "City.h"
#import "Airport.h"

#define MAS_SHORTHAND
#import "Masonry.h"

@interface MapController ()

@property (strong,nonatomic) NSArray *airports;
@property (strong,nonatomic) NSArray *airportsInRegion;
@property (strong,nonatomic) NSMutableArray *annotations;
@property (strong,nonatomic) MKMapView *mapView;

@end

@implementation MapController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    self.navigationController.navigationBar.hidden = YES;
        
    self.mapView = MKMapView.new;

    //CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.023502, 2.560485); //Бурж, Франция
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(52.281385, 104.293779); //Иркутск
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 100000, 100000);
    [self.mapView setRegion: region animated: YES];

    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    //MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    //annotation.title = @"I'm here!";
    //annotation.coordinate = CLLocationCoordinate2DMake(47.023502, 2.560485);
    //[mapView addAnnotation:annotation];

    self.airports = DataManager.shared.airports;
    NSLog(@"All airports count: %lu",(unsigned long)[self.airports count]);
    self.airportsInRegion = [self airportsInRegion:region];
    self.annotations = [self annotationsFromAirports:self.airportsInRegion];
    [self.mapView addAnnotations:self.annotations];

}

- (NSMutableArray *)airportsFilteredWith:(NSString *)countryCode {
    NSMutableArray *airports = NSMutableArray.new;
    for (Airport *airport in DataManager.shared.airports) {
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
    int i = 0;
    for (Airport *airport in self.airports) {
        //NSLog(@"%@,%f,%f",airport.name,airport.coordinate.latitude,airport.coordinate.longitude);
        CLLocation *airportLocation = [[CLLocation alloc] initWithLatitude:airport.coordinate.latitude longitude:airport.coordinate.longitude];
        if ([self region:region containsLocation:airportLocation]) {
            i++;
            [airports addObject:airport];
        }
    }
    //NSLog(@"Airports in region count: %d",i);
    return airports;
}

- (NSMutableArray *)annotationsFromAirports:(NSArray *)airports {
    NSMutableArray *annotations = NSMutableArray.new;
    for (Airport *airport in airports) {
        MKPointAnnotation *annotation = MKPointAnnotation.new;
        annotation.title = [self cityWithCityCode:airport.cityCode];
        annotation.subtitle = airport.name;
        annotation.coordinate = airport.coordinate;
        [annotations addObject:annotation];
    }
    return annotations;
}
         
- (NSString *)cityWithCityCode:(NSString *)cityCode {
    for (City *city in DataManager.shared.cities) {
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

/* Standardises and angle to [-180 to 180] degrees */
- (CLLocationDegrees)standardAngle:(CLLocationDegrees)angle {
    //angle %= 360;
    return angle < -180 ? -360 - angle : angle > 180 ? 360 - 180 : angle;
}

/* confirms that a region contains a location */
- (BOOL)region:(MKCoordinateRegion)region containsLocation:(CLLocation*)location {
    CLLocationDegrees deltaLat = fabs([self standardAngle:(region.center.latitude - location.coordinate.latitude)]);
    CLLocationDegrees deltalong = fabs([self standardAngle:(region.center.longitude - location.coordinate.longitude)]);
    return region.span.latitudeDelta >= deltaLat && region.span.longitudeDelta >= deltalong;
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"MarkerIdentifier";
    MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(0.0, 10.0);
        annotationView.glyphImage = [UIImage systemImageNamed:@"airplane"];
        annotationView.markerTintColor = [UIColor blueColor];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    annotationView.annotation = annotation;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSArray *newAirports = NSArray.new;
    NSArray *airportsToAdd = NSArray.new;
    NSArray *annotationsToAdd = NSArray.new;
    NSArray *annotationsToRemove = NSArray.new;

    //MKMapRect mapRect = mapView.visibleMapRect;
    //MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    //NSLog(@"region span: %f,%f",mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta);
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
}

- (void)mapViewDidChangeVisibleRegion:(MKMapView *)mapView {
}



@end
