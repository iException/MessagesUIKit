//
//  BXMessagesInputToolbarButton.m
//  Baixing
//
//  Created by hyice on 15/3/17.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesInputToolbarButton.h"
#import "NSBundle+MessagesUIKit.h"
#import "UIImage+MessagesUIKit.h"

@implementation BXMessagesInputToolbarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.flexibleHeight = NO;
        self.flexibleWidth = NO;
        
        self.width = 44.0f;
        self.height = 44.0f;
    }
    
    return self;
}

+ (BXMessagesInputToolbarButton *)buttonWithNormalImage:(NSString *)normalImage
                                         highlightImage:(NSString *)highlightImage
                                                 target:(id)target
                                               selector:(SEL)selector
{
    BXMessagesInputToolbarButton *btn = [BXMessagesInputToolbarButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage buk_imageNamed:normalImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage buk_imageNamed:highlightImage] forState:UIControlStateHighlighted];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

@end
