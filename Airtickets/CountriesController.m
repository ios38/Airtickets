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
#define MAS_SHORTHAND
#import "Masonry.h"

@interface CountriesController ()

@property (strong,nonatomic) NSMutableArray *countries;
@property (strong, nonatomic) UITableView* tableView;

@end

@implementation CountriesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countries = [NSMutableArray arrayWithArray:DataManager.shared.countries];

    self.navigationItem.title = [NSString stringWithFormat:@"Countries (%lu)", (unsigned long)[self.countries count]];
    
    UISearchBar *searchBar = UISearchBar.new;
    searchBar.delegate = self;
    searchBar.placeholder = @"search country";
    [self.view addSubview:searchBar];
    
    [searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.topMargin);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
    }];

    self.tableView = UITableView.new;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBar.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottomMargin);
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.hidden = YES;
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
