//
//  BXMessagesInputToolbarButton.h
//  Baixing
//
//  Created by hyice on 15/3/17.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXMessagesInputToolbar.h"

@interface BXMessagesInputToolbarButton : UIButton <BXMessagesInputToolbarItem>

@property (assign, nonatomic) BOOL flexibleHeight;

@property (assign, nonatomic) BOOL flexibleWidth;

@property (assign, nonatomic) CGFloat width;

@property (assign, nonatomic) CGFloat height;

+ (BXMessagesInputToolbarButton *)buttonWithNormalImage:(NSString *)normalImage
                                         highlightImage:(NSString *)highlightImage
                                                 target:(id)target
                                               selector:(SEL)selector;

@end
