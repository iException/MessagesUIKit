//
//  UIView+BXMessagesKit.m
//  Baixing
//
//  Created by hyice on 15/3/18.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "UIView+BXMessagesKit.h"

@implementation UIView(BXMessagesKit)

- (UIView *)bxMessagesKit_superSuperView
{
    UIView *view = self;
    while (view.superview) {
        view = view.superview;
    }
    
    return view;
}

- (void)bxMessagesKit_performOneItemConstraintAction:(void (^)(NSLayoutConstraint *constraint))action
                                              onItem:(UIView *)item
                                        forAttribute:(NSLayoutAttribute)attribute
{
    [item.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if ((constraint.firstItem == item
             && constraint.firstAttribute == attribute
             && constraint.secondItem == nil
             && constraint.secondAttribute == NSLayoutAttributeNotAnAttribute
             )
            ||
            (constraint.firstItem == nil
             && constraint.firstAttribute == NSLayoutAttributeNotAnAttribute
             && constraint.secondItem == item
             && constraint.secondAttribute == attribute
             )
           ) {
            
            action(constraint);
            
            *stop = YES;
        }
    }];
}

@end
