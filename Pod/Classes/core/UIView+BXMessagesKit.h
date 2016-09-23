//
//  UIView+BXMessagesKit.h
//  Baixing
//
//  Created by hyice on 15/3/18.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

@import UIKit;

@interface UIView(BXMessagesKit)

- (UIView *)bxMessagesKit_superSuperView;

- (void)bxMessagesKit_performOneItemConstraintAction:(void (^)(NSLayoutConstraint *constraint))action
                                              onItem:(UIView *)item
                                        forAttribute:(NSLayoutAttribute)attribute;
@end
