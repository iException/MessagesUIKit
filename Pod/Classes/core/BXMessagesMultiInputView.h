//
//  BXMessagesMultiInputView.h
//  Baixing
//
//  Created by hyice on 15/3/16.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

@import UIKit;

@class BXMessagesInputToolbar;
@class BXMessagesInputAccessoryView;

@interface BXMessagesMultiInputView : UIView

@property (strong, nonatomic) BXMessagesInputToolbar *inputToolbar;

@property (strong, nonatomic) BXMessagesInputAccessoryView *accessoryView;

@property (assign, nonatomic) BOOL isShowingAccessoryView;

/**
 *  Setup default toolbar items for view. In this core part, method
 *  doesn't add any items, but only handle the underground logic for
 *  you.
 *
 *  You need to subclass and override this method to provide your own
 *  items. For more details, you can dive into the quick kit.
 */
- (void)setupInputToolbarItems;

- (void)setupDefaultAccessoryItem;

- (void)showAccessoryView:(BOOL)show animated:(BOOL)animated;

@end
