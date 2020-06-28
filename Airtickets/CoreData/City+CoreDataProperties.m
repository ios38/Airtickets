//
//  City+CoreDataProperties.m
//  Airtickets
//
//  Created by Maksim Romanov on 28.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//
//

#import "City+CoreDataProperties.h"

@implementation City (CoreDataProperties)

+ (NSFetchRequest<City *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"City"];
}

@dynamic country;
@dynamic airports;

@end
