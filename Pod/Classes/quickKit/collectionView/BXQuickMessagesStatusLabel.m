//
//  BXQuickMessagesStatusLabel.m
//  Baixing
//
//  Created by hyice on 15/3/31.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXQuickMessagesStatusLabel.h"

@implementation BXQuickMessagesStatusLabel

- (instancetype)initWithInsets:(UIEdgeInsets)insets
{
    self = [super initWithInsets:insets];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0xae/255.0 green:0xae/255.0 blue:0xae/255.0 alpha:1.0];
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:14];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    
    return self;
}





@end
