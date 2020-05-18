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

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, screen.bounds.size.width, 40)];
    label.text = [NSString stringWithFormat:@"Countries (%lu)", (unsigned long)[self.countries count]];
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    label.backgroundColor = [UIColor darkGrayColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 90, screen.bounds.size.width, 40)];
    searchBar.delegate = self;
    searchBar.placeholder = @"search country";
    [self.view addSubview:searchBar];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, screen.bounds.size.width, screen.bounds.size.height - 200)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.tableView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.tableView];


    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, screen.bounds.size.height - 70, screen.bounds.size.width, 40)];
    [button addTarget:self action:@selector(nextScreen:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor darkGrayColor];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    //[self.view addSubview:button];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void) nextScreen: (UIButton *)button {
    UIViewController *citiesController = [[CitiesController alloc] init];
    [self.navigationController pushViewController:citiesController animated:YES];
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
