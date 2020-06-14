//
//  LocationService.h
//  Lesson1
//
//  Created by Maksim Romanov on 09.06.2020.
//  Copyright © 2020 Elena Gracheva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"

NS_ASSUME_NONNULL_BEGIN

#define kLocationServiceDidUpdateCurrentLocation @"LocationServiceDidUpdateCurrentLocation"

@interface LocationService : NSObject

@end

NS_ASSUME_NONNULL_END
