//
//  Airport+CoreDataProperties.m
//  Airtickets
//
//  Created by Maksim Romanov on 28.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//
//

#import "Airport+CoreDataProperties.h"

@implementation Airport (CoreDataProperties)

+ (NSFetchRequest<Airport *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Airport"];
}

@dynamic city;

@end
