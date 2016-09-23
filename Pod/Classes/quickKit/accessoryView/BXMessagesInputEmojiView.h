//
//  BXMessagesInputEmojiView.h
//  Baixing
//
//  Created by hyice on 15/3/20.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesInputAccessoryView.h"

@class BXMessagesInputEmojiView;

@protocol BXMessagesInputEmojiViewDelegate <NSObject>

@optional

- (void)bxMessagesInputEmojiView:(BXMessagesInputEmojiView *)emojiView deleteButtonPressed:(UIButton *)deleteButton;
- (void)bxMessagesInputEmojiView:(BXMessagesInputEmojiView *)emojiView sendButtonPressed:(UIButton *)sendButton;
- (void)bxMessagesInputEmojiView:(BXMessagesInputEmojiView *)emojiView selectedEmoji:(NSString *)emoji;

@end

@interface BXMessagesInputEmojiView : UIView <BXMessagesInputAccessoryItem>

@property (assign, nonatomic) BOOL flexibleHeight;

@property (assign, nonatomic) BOOL flexibleWidth;

@property (assign, nonatomic) CGFloat height;

@property (weak, nonatomic) id<BXMessagesInputEmojiViewDelegate> delegate;

@end
