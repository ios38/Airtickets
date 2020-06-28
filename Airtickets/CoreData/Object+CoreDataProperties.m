//
//  Object+CoreDataProperties.m
//  Airtickets
//
//  Created by Maksim Romanov on 28.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//
//

#import "Object+CoreDataProperties.h"

@implementation Object (CoreDataProperties)

+ (NSFetchRequest<Object *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Object"];
}

@dynamic name;
@dynamic code;

@end
