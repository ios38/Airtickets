//
//  Country+CoreDataProperties.m
//  Airtickets
//
//  Created by Maksim Romanov on 28.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//
//

#import "Country+CoreDataProperties.h"

@implementation Country (CoreDataProperties)

+ (NSFetchRequest<Country *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Country"];
}

@dynamic cities;

@end
