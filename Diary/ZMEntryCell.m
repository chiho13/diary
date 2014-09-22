//
//  ZMEntryCell.m
//  Diary
//
//  Created by Anthony Ho on 16/09/2014.
//  Copyright (c) 2014 ZeroMondays. All rights reserved.
//

#import "ZMEntryCell.h"
#import "ZMDiaryEntry.h"
#import <QuartzCore/QuartzCore.h>

@interface ZMEntryCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;

@end

@implementation ZMEntryCell

+(CGFloat)heightForEntry:(ZMDiaryEntry *)entry{
    const CGFloat topMargin= 35.0f;
    const CGFloat bottomMargin = 80.0f;
    const CGFloat minHeight= 106.0f;
    
    UIFont * font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGRect boundingBox = [entry.body boundingRectWithSize:CGSizeMake(202, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: font} context:nil];
    
    return MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin +bottomMargin);
}

-(void)configureCellForEntry:(ZMDiaryEntry*) entry{
    self.bodyLabel.text = entry.body;
    _bodyLabel.numberOfLines = 0;
    self.locationLabel.text= entry.location;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE d MMM yyyy"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    if (entry.imageData){
        self.mainImageView.image = [UIImage imageWithData:entry.imageData];
    } else{
        self.mainImageView.image = [UIImage imageNamed:@"icn_noimage"];
    }
    self.mainImageView.layer.cornerRadius = CGRectGetWidth(self.mainImageView.frame) / 2.0f;

    
    if (entry.mood == ZMDiaryEntryMoodGood){
        self.moodImageView.image = [UIImage imageNamed:@"icn_happy"];
    } else if(entry.mood == ZMDiaryEntryMoodAverage){
        self.moodImageView.image = [UIImage imageNamed:@"icn_average"];
 
    } else if (entry.mood == ZMDiaryEntryMoodBad){
        self.moodImageView.image = [UIImage imageNamed:@"icn_bad"];
   
    }
    
    if(entry.location.length > 0 ){
        self.locationLabel.text = entry.location;
    } else{
        self.locationLabel.text = @"No Location";
    }
   
    
    
}


@end
