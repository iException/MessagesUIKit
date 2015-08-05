//
//  BXMessagesInputAccessoryView.h
//  Baixing
//
//  Created by hyice on 15/3/18.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BXMessagesInputAccessoryItem <NSObject>

@property (assign, nonatomic) BOOL flexibleHeight;

@property (assign, nonatomic) BOOL flexibleWidth;


@optional

@property (assign, nonatomic) CGFloat height;

@property (assign, nonatomic) CGFloat width;

@end

@interface BXMessagesInputAccessoryView : UIView

- (void)displayAccessoryItem:(UIView<BXMessagesInputAccessoryItem> *)item
                    animated:(BOOL)animated;

- (void)removeAccessoryItem:(UIView<BXMessagesInputAccessoryItem> *)item
                   animated:(BOOL)animated;

@end
