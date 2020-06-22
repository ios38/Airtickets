//
//  TabBarController.m
//  Airtickets
//
//  Created by Maksim Romanov on 21.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "TabBarController.h"
#import "ViewController.h"
#import "CountriesController.h"
#import "MapController.h"

@interface TabBarController ()

@end

@implementation TabBarController


- (instancetype)init
{
    self = [super init];
    if (self) {
        ViewController *vc = [[ViewController alloc] init];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Main Menu" image:[UIImage systemImageNamed:@"return"] tag:1];

        CountriesController *countriesVC = [[CountriesController alloc] init];
        countriesVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"From List" image:[UIImage systemImageNamed:@"doc.text.magnifyingglass"] tag:2];

        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:countriesVC];
        
        MapController *mapVC = [[MapController alloc] init];
        mapVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"From Map" image:[UIImage systemImageNamed:@"mappin.and.ellipse"] tag:3];

        self.viewControllers = @[vc, nc, mapVC];
        //self.hidesBottomBarWhenPushed = YES;
        self.selectedIndex = 1;

    }
    return self;
}

@end
