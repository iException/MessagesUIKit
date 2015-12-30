//
//  BXQuickMessagesInsetsLabel.m
//  Baixing
//
//  Created by hyice on 15/4/1.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXQuickMessagesInsetsLabel.h"

@implementation BXQuickMessagesInsetsLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame insets:UIEdgeInsetsZero];
}

- (instancetype)initWithInsets:(UIEdgeInsets)insets
{
    return [self initWithFrame:CGRectZero insets:insets];
}

- (instancetype)initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textInsets = insets;
    }
    return self;
}

@end
