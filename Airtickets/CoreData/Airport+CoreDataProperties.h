//
//  Airport+CoreDataProperties.h
//  Airtickets
//
//  Created by Maksim Romanov on 28.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//
//

#import "Airport+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Airport (CoreDataProperties)

+ (NSFetchRequest<Airport *> *)fetchRequest;

@property (nullable, nonatomic, retain) City *city;

@end

NS_ASSUME_NONNULL_END
