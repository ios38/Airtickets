//
//  CitiesController.m
//  Airtickets
//
//  Created by Maksim Romanov on 28.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "CitiesController.h"
#import "City+CoreDataProperties.h"
#import "AirportsController.h"

@interface CitiesController ()

@property(strong,nonatomic) NSPredicate* predicate;

@end

@implementation CitiesController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Cities";
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = NSFetchRequest.new;
    NSEntityDescription* description = [NSEntityDescription entityForName:@"City" inManagedObjectContext:self.context];
    [fetchRequest setEntity:description];
    //[fetchRequest setFetchBatchSize:20];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    self.predicate = [NSPredicate predicateWithFormat:@"country == %@",self.country ];
    [fetchRequest setPredicate:self.predicate];

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    self.navigationItem.title = [NSString stringWithFormat: @"Cities (%lu)",(unsigned long)[[aFetchedResultsController fetchedObjects] count]];
    //NSLog(@"fetchedObjects: %lu", (unsigned long)[[aFetchedResultsController fetchedObjects] count]);
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}
#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    City *city = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = city.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"airports: %lu",(unsigned long)[city.airports count]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    City *city = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"did select city: %@",city.name);
    AirportsController *vc = AirportsController.new;
    vc.city = city;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UISearchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText  isEqual: @""]) {
        [self.fetchedResultsController.fetchRequest setPredicate:self.predicate];
    } else {
        NSMutableArray *predicateArray = [ NSMutableArray arrayWithObject: self.predicate];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@",searchText];
        [predicateArray addObject:predicate];
        NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:
        predicateArray];
        [self.fetchedResultsController.fetchRequest setPredicate:compoundPredicate];
    }
    [self.fetchedResultsController performFetch:nil];
    self.navigationItem.title = [NSString stringWithFormat: @"Cities (%lu)",(unsigned long)[[self.fetchedResultsController fetchedObjects] count]];
    //NSLog(@"fetchedObjects: %lu",(unsigned long)[[self.fetchedResultsController fetchedObjects] count]);
    [self.tableView reloadData];
}

@end

/*
 placePredicate = [NSPredicate predicateWithFormat:@"place CONTAINS[cd] %@",placeTextField.text];
 NSMutableArray *compoundPredicateArray = [ NSMutableArray arrayWithObject: placePredicate ];

 if( selectedCategory != nil ) // or however you need to test for an empty category
     {
     categoryPredicate = [NSPredicate predicateWithFormat:@"category CONTAINS[cd] %@",selectedCategory];
     [ compoundPredicateArray addObject: categoryPredicate ];
     }

 // and similarly for the other elements.
 */
