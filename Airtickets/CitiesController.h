//
//  CitiesController.h
//  Airtickets
//
//  Created by Maksim Romanov on 17.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

NS_ASSUME_NONNULL_BEGIN

@interface CitiesController : UIViewController <UITableViewDataSource, UITableViewDelegate>

-(instancetype)initWithCountry:(Country *)country;

@end

NS_ASSUME_NONNULL_END
