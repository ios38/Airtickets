//
//  AirportsController.h
//  Airtickets
//
//  Created by Maksim Romanov on 18.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

NS_ASSUME_NONNULL_BEGIN

@interface AirportsController : UIViewController <UITableViewDataSource,UITableViewDelegate>

-(instancetype)initWithCity:(City *)city;

@end

NS_ASSUME_NONNULL_END
