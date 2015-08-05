//
//  BXQuickMessagesInsetsLabel.h
//  Baixing
//
//  Created by hyice on 15/4/1.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXQuickMessagesInsetsLabel : UILabel

@property (assign, nonatomic) UIEdgeInsets insets;

- (instancetype)initWithInsets:(UIEdgeInsets)insets;

@end
