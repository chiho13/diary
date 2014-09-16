//
//  ZMDiaryEntry.h
//  Diary
//
//  Created by Anthony Ho on 08/09/2014.
//  Copyright (c) 2014 ZeroMondays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


NS_ENUM(int16_t, ZMDiaryEntryMood) {
    ZMDiaryEntryMoodGood =0,
    ZMDiaryEntryMoodAverage=1,
    ZMDiaryEntryMoodBad = 2,
    
    
};
@interface ZMDiaryEntry : NSManagedObject


@property (nonatomic) NSTimeInterval date;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic) int16_t mood;
@property (nonatomic, retain) NSString * location;

@property (nonatomic, readonly)NSString *sectionName;

@end
