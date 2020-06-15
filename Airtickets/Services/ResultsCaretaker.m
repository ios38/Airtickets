//
//  ResultsCaretaker.m
//  Millionaire
//
//  Created by Maksim Romanov on 10.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "ResultsCaretaker.h"

@implementation ResultsCaretaker

NSString *filePath() {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/Airtickets"];
    //NSLog(@"%@",filePath);
    return filePath;
}

-(void) saveResults:(NSMutableArray *)gameResults {
    /*
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    if (gameResults != nil) {
        [dataDict setObject:gameResults forKey:@"gameResults"];
    }*/
    
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameResults requiringSecureCoding:NO error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    [data writeToFile: filePath() atomically:YES];
    //NSLog(@"gameResults saved!");
}

-(NSMutableArray *) loadResults {
    NSMutableArray *gameResults = [NSMutableArray array];
    /*
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:filePath()];
    if (data != nil) {
        NSArray *objectClasses = @[[NSArray class], [GameResult class], [NSDate class]];
        NSMutableArray *results = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithArray:objectClasses] fromData:data error:&error];
        
        if (error) {
            NSLog(@"%@",error);
        }

        for (GameResult *result in results) {
            [gameResults addObject:result];
        }
    }*/
    return gameResults;
}

@end
