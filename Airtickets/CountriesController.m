//
//  CountriesController.m
//  Airtickets
//
//  Created by Maksim Romanov on 17.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "CountriesController.h"
#import "CitiesController.h"
#import "DataManager.h"
#import "Country.h"

@interface CountriesController ()

@property (strong,nonatomic) NSMutableArray *countries;
@property (strong, nonatomic) UITableView* tableView;

@end

@implementation CountriesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countries = [NSMutableArray arrayWithArray:DataManager.shared.countries];

    UIScreen *screen = [UIScreen mainScreen];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Countries (%lu)", (unsigned long)[self.countries count]];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 30, screen.bounds.size.width, 40)];
    searchBar.delegate = self;
    searchBar.placeholder = @"search country";
    [self.view addSubview:searchBar];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, screen.bounds.size.width, screen.bounds.size.height - 140)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.tableView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.tableView];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (NSMutableArray *)countriesFilteredWith:(NSString *)text{
    NSMutableArray *countries = [NSMutableArray array];
    for (Country *country in DataManager.shared.countries) {
        if ([country.name containsString:text]) {
            [countries addObject:country];
        }
    }
    return countries;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.countries count];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *countryCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"countryCell"];
    Country *country = [self.countries objectAtIndex:indexPath.row];
    countryCell.textLabel.text = country.name;
    
    return countryCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Country *country = [self.countries objectAtIndex:indexPath.row];
    UIViewController *citiesController = [[CitiesController alloc] initWithCountry:country];
    [self.navigationController pushViewController:citiesController animated:YES];
}

#pragma mark - UISearchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText  isEqual: @""]) {
        self.countries = [NSMutableArray arrayWithArray:DataManager.shared.countries];
        [self.tableView reloadData];
    } else {
        self.countries = [self countriesFilteredWith:searchText];
        [self.tableView reloadData];
    }
}

@end
