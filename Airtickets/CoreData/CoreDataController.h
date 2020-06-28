//
//  CoreDataController.h
//  Airtickets
//
//  Created by Maksim Romanov on 28.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataController : UIViewController <NSFetchedResultsControllerDelegate>

@property(strong,nonatomic) NSManagedObjectContext *context;
@property(strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

NS_ASSUME_NONNULL_END
