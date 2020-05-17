//
//  ViewController.m
//  Airtickets
//
//  Created by Maksim Romanov on 17.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"
#import "CountriesController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScreen *screen = [UIScreen mainScreen];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete:) name:kDataManagerLoadDataDidComplete object:nil];

    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    activityView.tintColor = [UIColor blackColor];
    activityView.frame = CGRectMake((screen.bounds.size.width - activityView.frame.size.width)/2, (screen.bounds.size.height - activityView.frame.size.height)/2, activityView.frame.size.width, activityView.frame.size.height);
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
    [[DataManager shared] loadData];
}

- (void)loadDataComplete:(NSNotification *)notification {
    UIViewController *countriesController = [[CountriesController alloc] init];
    [self.navigationController pushViewController:countriesController animated:NO];
}


@end
