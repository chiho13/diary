//
//  ZMEntryCell.h
//  Diary
//
//  Created by Anthony Ho on 16/09/2014.
//  Copyright (c) 2014 ZeroMondays. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZMDiaryEntry;
@interface ZMEntryCell : UITableViewCell

+(CGFloat)heightForEntry:(ZMDiaryEntry *)entry;

-(void)configureCellForEntry:(ZMDiaryEntry*) entry;
@end
