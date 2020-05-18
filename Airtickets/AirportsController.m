//
//  AirportsController.m
//  Airtickets
//
//  Created by Maksim Romanov on 18.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "AirportsController.h"
#import "DataManager.h"
#import "Airport.h"

@interface AirportsController ()

@property (strong,nonatomic) NSMutableArray *airports;

@end

@implementation AirportsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.airports = [NSMutableArray arrayWithArray:DataManager.shared.airports];

    UIScreen *screen = [UIScreen mainScreen];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, screen.bounds.size.width, 40)];
    label.text = [NSString stringWithFormat:@"Airports count: %lu", (unsigned long)[self.airports count]];
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    label.backgroundColor = [UIColor darkGrayColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, screen.bounds.size.width, screen.bounds.size.height - 160)];
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.airports count];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *airportCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"airportCell"];
    Country *airport = [self.airports objectAtIndex:indexPath.row];
    airportCell.textLabel.text = airport.name;
    
    return airportCell;
}

@end
