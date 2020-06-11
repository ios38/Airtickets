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

@interface MapController ()

@property (strong,nonatomic) NSMutableArray *airports;
@property (strong,nonatomic) MKMapView *mapView;

@end

@implementation MapController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    self.navigationController.navigationBar.hidden = YES;

    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.mapView = [[MKMapView alloc] initWithFrame: frame];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.023502, 2.560485);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 100000, 100000);
    
    [self.mapView setRegion: region animated: YES];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    //MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    //annotation.title = @"I'm here!";
    //annotation.coordinate = CLLocationCoordinate2DMake(47.023502, 2.560485);
    //[mapView addAnnotation:annotation];

    NSString *countryQuery = @"France";
    NSString *countryCode = [self countryCodeWithQuery:countryQuery];
    self.airports = [self airportsFilteredWith:(NSString *)countryCode];
    [self viewAirportsForRegion:region];

}

- (void)viewAirportsForRegion:(MKCoordinateRegion) region {
    int i = 0;
    for (Airport *airport in self.airports) {
        //NSLog(@"%@,%f,%f",airport.name,airport.coordinate.latitude,airport.coordinate.longitude);
        CLLocation *airportLocation = [[CLLocation alloc] initWithLatitude:airport.coordinate.latitude longitude:airport.coordinate.longitude];
        
        if ([self region:region containsLocation:airportLocation]) {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            //NSLog(@"%@",[self cityWithCityCode:airport.cityCode]);
            annotation.title = [self cityWithCityCode:airport.cityCode];
            //annotation.title = airport.cityCode;
            annotation.subtitle = airport.name;
            annotation.coordinate = airport.coordinate;
            i++;
            [self.mapView addAnnotation:annotation];
        }
    }
    NSLog(@"Airports in visible region: %d",i);

}

- (NSMutableArray *)airportsFilteredWith:(NSString *)countryCode {
    NSMutableArray *airports = [NSMutableArray array];
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

- (NSString *)countryCodeWithQuery:(NSString *)countryQuery{
    NSString *countryCode = @"";
    for (Country *country in DataManager.shared.countries) {
        if ([country.name isEqualToString:countryQuery]) {
            countryCode = country.code;
        }
    }
    return countryCode;
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

- (void)mapViewDidChangeVisibleRegion:(MKMapView *)mapView {
    MKMapRect mapRect = mapView.visibleMapRect;
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    [self viewAirportsForRegion:region];
}

@end
