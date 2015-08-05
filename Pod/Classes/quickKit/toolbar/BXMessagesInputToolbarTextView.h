//
//  BXMessagesInputToolbarTextView.h
//  Baixing
//
//  Created by hyice on 15/3/17.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXMessagesInputToolbar.h"

@interface BXMessagesInputToolbarTextView : UIView <BXMessagesInputToolbarItem>

// BXMessagesInputToolbarItem protocal part
@property (assign, nonatomic) BOOL flexibleHeight;

@property (assign, nonatomic) BOOL flexibleWidth;

@property (assign, nonatomic) CGFloat height;

// self part
@property (strong, nonatomic) UIImage *backgroundImage;

@property (strong, nonatomic, readonly) UITextView *textView;

@property (assign, nonatomic) NSInteger maxVisibleNumberOfLines;

@property (assign, nonatomic) UIEdgeInsets textViewInsets;

@end
