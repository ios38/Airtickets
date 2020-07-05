//
//  AirportsController.h
//  Airtickets
//
//  Created by Maksim Romanov on 28.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "CoreDataController.h"

NS_ASSUME_NONNULL_BEGIN

@class City;

@interface AirportsController : CoreDataController

@property (strong,nonatomic) City *city;

@end

NS_ASSUME_NONNULL_END
