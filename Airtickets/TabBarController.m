//
//  TabBarController.m
//  Airtickets
//
//  Created by Maksim Romanov on 21.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "TabBarController.h"
#import "CountriesController.h"
#import "MapController.h"

@interface TabBarController ()

@end

@implementation TabBarController


- (instancetype)init
{
    self = [super init];
    if (self) {

        CountriesController *countriesVC = [[CountriesController alloc] init];
        countriesVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"From List" image:[UIImage systemImageNamed:@"doc.text.magnifyingglass"] tag:1];

        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:countriesVC];
        
        MapController *mapVC = [[MapController alloc] init];
        mapVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"From Map" image:[UIImage systemImageNamed:@"mappin.and.ellipse"] tag:2];

        self.viewControllers = @[nc, mapVC];
        //self.hidesBottomBarWhenPushed = YES;
        self.selectedIndex = 0;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
