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
        self.insets = insets;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    UIEdgeInsets insets = self.insets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x -= insets.left;
    rect.origin.y -= insets.top;
    rect.size.width += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    
    return rect;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end
