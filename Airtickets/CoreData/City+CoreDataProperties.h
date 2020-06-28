//
//  City+CoreDataProperties.h
//  Airtickets
//
//  Created by Maksim Romanov on 28.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//
//

#import "City+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface City (CoreDataProperties)

+ (NSFetchRequest<City *> *)fetchRequest;

@property (nullable, nonatomic, retain) Country *country;
@property (nullable, nonatomic, retain) NSSet<Airport *> *airports;

@end

@interface City (CoreDataGeneratedAccessors)

- (void)addAirportsObject:(Airport *)value;
- (void)removeAirportsObject:(Airport *)value;
- (void)addAirports:(NSSet<Airport *> *)values;
- (void)removeAirports:(NSSet<Airport *> *)values;

@end

NS_ASSUME_NONNULL_END
