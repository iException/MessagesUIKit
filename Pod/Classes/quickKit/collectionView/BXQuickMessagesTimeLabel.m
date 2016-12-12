//
//  BXQuickMessagesTimeLabel.m
//  Baixing
//
//  Created by hyice on 15/3/31.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXQuickMessagesTimeLabel.h"

@interface BXQuickMessagesTimeLabel()

@property (strong, nonatomic) NSCalendar *calendar;

@end

@implementation BXQuickMessagesTimeLabel

- (instancetype)initWithInsets:(UIEdgeInsets)insets
{
    self = [super initWithInsets:insets];
    if (self) {
        self.textColor = [UIColor colorWithRed:0.502f green:0.549f blue:0.612f alpha:1.0f];
        self.font = [UIFont systemFontOfSize:12];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)showTimeWithDate:(NSDate *)date
{
    static NSCalendarUnit componentsUnit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;
    
    NSDateComponents *dateComponents =  [self.calendar components:componentsUnit fromDate:date];
    NSDateComponents *nowComponents = [self.calendar components:componentsUnit fromDate:[NSDate date]];
    
    NSString *displayText;
    if (dateComponents.day == nowComponents.day
        && dateComponents.month == nowComponents.month
        && dateComponents.year == nowComponents.year
       ) {
        displayText = [NSString stringWithFormat:@"%ld:%02ld", (long)dateComponents.hour, (long)dateComponents.minute];
    }else {
        NSDateComponents *addComponents = [[NSDateComponents alloc] init];
        [addComponents setDay:-1];
        NSDate *yesterday = [self.calendar dateByAddingComponents:addComponents toDate:[NSDate date] options:0];
        NSDateComponents *yesterdayComponents = [self.calendar components:componentsUnit fromDate:yesterday];
        
        if (yesterdayComponents.day == dateComponents.day
            && yesterdayComponents.month == dateComponents.month
            && yesterdayComponents.year == dateComponents.year) {
            displayText = [NSString stringWithFormat:@"昨天 %ld:%02ld", (long)dateComponents.hour, (long)dateComponents.minute];
        }else if(dateComponents.year == nowComponents.year) {
            displayText = [NSString stringWithFormat:@"%ld月%ld日 %ld:%02ld",
                           (long)dateComponents.month,
                           (long)dateComponents.day,
                           (long)dateComponents.hour,
                           (long)dateComponents.minute];
        }else {
            displayText = [NSString stringWithFormat:@"%ld年%ld月%ld日 %ld:%02ld",
                           (long)dateComponents.year,
                           (long)dateComponents.month,
                           (long)dateComponents.day,
                           (long)dateComponents.hour,
                           (long)dateComponents.minute];

        }
    }
    
    self.text = displayText;
}

- (NSCalendar *)calendar
{
    if (!_calendar) {
        _calendar = [NSCalendar autoupdatingCurrentCalendar];
    }
    
    return _calendar;
}

@end
