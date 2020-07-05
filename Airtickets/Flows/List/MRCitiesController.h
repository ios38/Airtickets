//
//  CitiesController.h
//  Airtickets
//
//  Created by Maksim Romanov on 17.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCountry.h"

NS_ASSUME_NONNULL_BEGIN

@interface MRCitiesController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

-(instancetype)initWithCountry:(MRCountry *)country;

@end

NS_ASSUME_NONNULL_END
