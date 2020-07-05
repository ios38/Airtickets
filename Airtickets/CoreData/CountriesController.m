//
//  CountriesController.m
//  Airtickets
//
//  Created by Maksim Romanov on 28.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "CountriesController.h"
#import "Country+CoreDataProperties.h"
#import "CitiesController.h"
#import "DataManager.h"
//#import "Animator.h"

@interface CountriesController ()

//@property (strong, nonatomic) Animator * animator;

@end

@implementation CountriesController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Countries";
    [DataManager.shared deleteAllObjects];
    //[DataManager.shared loadData];
    //[DataManager.shared backup];
    [DataManager.shared restore];
    //[DataManager.shared printAllObjects];
    
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = NSFetchRequest.new;
    NSEntityDescription* description = [NSEntityDescription entityForName:@"Country" inManagedObjectContext:self.context];
    [fetchRequest setEntity:description];
    //[fetchRequest setFetchBatchSize:20];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    self.navigationItem.title = [NSString stringWithFormat: @"Countries (%lu)",(unsigned long)[[aFetchedResultsController fetchedObjects] count]];
    //NSLog(@"fetchedObjects: %lu", (unsigned long)[[aFetchedResultsController fetchedObjects] count]);
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Country *country = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = country.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"cities: %lu",(unsigned long)[country.cities count]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Country *country = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"did select country: %@",country.name);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CitiesController *vc = CitiesController.new;
    vc.country = country;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText  isEqual: @""]) {
        [self.fetchedResultsController.fetchRequest setPredicate:nil];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@",searchText];
        [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    }
    [self.fetchedResultsController performFetch:nil];
    self.navigationItem.title = [NSString stringWithFormat: @"Countries (%lu)",(unsigned long)[[self.fetchedResultsController fetchedObjects] count]];
    //NSLog(@"fetchedObjects: %lu",(unsigned long)[[self.fetchedResultsController fetchedObjects] count]);
    [self.tableView reloadData];
}


@end
