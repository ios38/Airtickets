//
//  Object+CoreDataProperties.h
//  Airtickets
//
//  Created by Maksim Romanov on 28.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//
//

#import "Object+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Object (CoreDataProperties)

+ (NSFetchRequest<Object *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *code;

@end

NS_ASSUME_NONNULL_END
