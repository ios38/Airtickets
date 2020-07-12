//
//  AirportsController.m
//  Airtickets
//
//  Created by Maksim Romanov on 28.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "AirportsController.h"
#import "Airport+CoreDataProperties.h"
#import "City+CoreDataProperties.h"

@interface AirportsController ()

@property(strong,nonatomic) NSPredicate* predicate;

@end

@implementation AirportsController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"airportsTitle", @"");
    ;
}

- (void)setCity:(City *)city {
    _city = city;
    [_fetchedResultsController performFetch:nil];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = NSFetchRequest.new;
    NSEntityDescription* description = [NSEntityDescription entityForName:@"Airport" inManagedObjectContext:self.context];
    [fetchRequest setEntity:description];
    //[fetchRequest setFetchBatchSize:20];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:self.localizedName ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    self.predicate = [NSPredicate predicateWithFormat:@"city == %@",self.city ];
    [fetchRequest setPredicate:self.predicate];

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    self.navigationItem.title = [NSString stringWithFormat: @"%@ (%lu)",NSLocalizedString(@"airportsTitle", @""),(unsigned long)[[aFetchedResultsController fetchedObjects] count]];
    //NSLog(@"fetchedObjects: %lu", (unsigned long)[[aFetchedResultsController fetchedObjects] count]);
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Airport *airport = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [airport valueForKey:self.localizedName];
    cell.detailTextLabel.text = nil;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Airport *airport = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"did select airport: %@",[airport valueForKey:self.localizedName]);
}

#pragma mark - UISearchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText  isEqual: @""]) {
        [self.fetchedResultsController.fetchRequest setPredicate:self.predicate];
    } else {
        NSMutableArray *predicateArray = [ NSMutableArray arrayWithObject: self.predicate];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@",self.localizedName,searchText];
        [predicateArray addObject:predicate];
        NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:
        predicateArray];
        [self.fetchedResultsController.fetchRequest setPredicate:compoundPredicate];
    }
    [self.fetchedResultsController performFetch:nil];
    self.navigationItem.title = [NSString stringWithFormat: @"%@ (%lu)",NSLocalizedString(@"airportsTitle", @""),(unsigned long)[[self.fetchedResultsController fetchedObjects] count]];
    //NSLog(@"fetchedObjects: %lu",(unsigned long)[[self.fetchedResultsController fetchedObjects] count]);
    [self.tableView reloadData];
}


@end
