//
//  BXMessagesInputStickerDefaultEmojiView.h
//  Pods
//
//  Created by Xiang Li on 10/28/15.
//
//

@import UIKit;

@class BXMessagesInputStickerDefaultEmojiView;

@protocol BXMessagesInputStickerDefaultEmojiViewDelegate <NSObject>

- (void)bxMessagesInputStickerDefaultEmojiView:(BXMessagesInputStickerDefaultEmojiView *)emojiView selectedEmoji:(NSString *)emoji;

@end

@interface BXMessagesInputStickerDefaultEmojiView : UIView

@property (nonatomic, weak) id<BXMessagesInputStickerDefaultEmojiViewDelegate> delegate;

@end
