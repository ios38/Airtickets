//
//  ResultsCaretaker.h
//  Millionaire
//
//  Created by Maksim Romanov on 10.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResultsCaretaker : NSObject

-(void) saveResults:(NSMutableArray *)gameResults;
-(NSMutableArray *) loadResults;

@end

NS_ASSUME_NONNULL_END
