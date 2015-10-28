//
//  BXMessagesInputStickerView.h
//  Pods
//
//  Created by Xiang Li on 10/27/15.
//
//

#import <UIKit/UIKit.h>
#import "BXMessagesInputAccessoryView.h"

@class BXMessagesInputStickerView;

@protocol BXMessagesInputStickerViewDelegate <NSObject>

- (void)bxMessagesInputStickerView:(BXMessagesInputStickerView *)stickerView selectedEmoji:(NSString *)emoji;
- (void)bxMessagesInputStickerView:(BXMessagesInputStickerView *)stickerView deleteButtonPressed:(UIButton *)deleteButton;
- (void)bxMessagesInputStickerView:(BXMessagesInputStickerView *)stickerView sendButtonPressed:(UIButton *)sendButton;

@end

@interface BXMessagesInputStickerView : UIView <BXMessagesInputAccessoryItem>

@property (assign, nonatomic) BOOL flexibleHeight;

@property (assign, nonatomic) BOOL flexibleWidth;

@property (assign, nonatomic) CGFloat height;

@property (weak, nonatomic) id<BXMessagesInputStickerViewDelegate> delegate;

@end
