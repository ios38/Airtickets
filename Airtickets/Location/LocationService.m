//
//  LocationService.m
//  Lesson1
//
//  Created by Maksim Romanov on 09.06.2020.
//  Copyright © 2020 Elena Gracheva. All rights reserved.
//

#import "LocationService.h"
#import "UIKit/UIKit.h"

@interface LocationService () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocation *nearestCities;

@end

@implementation LocationService

- (instancetype)init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestAlwaysAuthorization];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    } else if (status != kCLAuthorizationStatusNotDetermined) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Упс!" message:@"Не удалось определить текущий город!" preferredStyle: UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Закрыть" style:(UIAlertActionStyleDefault) handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if (!self.currentLocation) {
        self.currentLocation = [locations firstObject];
        [self.locationManager stopUpdatingLocation];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationServiceDidUpdateCurrentLocation object:self.currentLocation];
    }
    [self.locationManager stopUpdatingLocation];
    
    for (CLLocation *location in locations) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        __block NSString *cityFromLocation = @"";
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks firstObject];
                cityFromLocation = placemark.locality;
                NSLog(@"cityFromLocation: %@",cityFromLocation);
            }
        }];
    }
}

- (NSString *)addressFromLocation:(CLLocation *)location {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __block NSString *cityFromLocation = @"";
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks firstObject];
            cityFromLocation = placemark.locality;
            NSLog(@"cityFromLocation: %@",cityFromLocation);
        }
    }];
    return cityFromLocation;
}

@end
