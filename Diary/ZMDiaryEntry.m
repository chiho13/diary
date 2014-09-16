//
//  ZMDiaryEntry.m
//  Diary
//
//  Created by Anthony Ho on 08/09/2014.
//  Copyright (c) 2014 ZeroMondays. All rights reserved.
//

#import "ZMDiaryEntry.h"


@implementation ZMDiaryEntry

@dynamic date;
@dynamic body;
@dynamic imageData;
@dynamic mood;
@dynamic location;

-(NSString *)sectionName {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    
    return [dateFormatter stringFromDate: date];
}

@end
