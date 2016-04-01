//
//  BXQuickMessagesMultiInputView.h
//  Baixing
//
//  Created by hyice on 15/3/22.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesMultiInputView.h"

@class BXMessagesInputMoreChoiceItem;
@class BXMessagesInputToolbarButton;
@class BXMessagesInputToolbarTextView;
@class BXMessagesInputToolbarAudioButton;

@protocol BXQuickMessagesMultiInputViewDelegate <NSObject>

@optional

- (void)bxQuickMessagesMultiInputView:(BXMessagesMultiInputView *)multiInputView sendText:(NSString *)text;
- (void)bxQuickMessagesMultiInputView:(BXMessagesMultiInputView *)multiInputView sendSticker:(id)stickerInfo;
- (void)bxQuickMessagesMultiInputView:(BXMessagesMultiInputView *)multiInputView startRecordAudio:(UIButton *)audioButton;
- (void)bxQuickMessagesMultiInputView:(BXMessagesMultiInputView *)multiInputView finishRecordAudio:(UIButton *)audioButton;
- (void)bxQuickMessagesMultiInputView:(BXMessagesMultiInputView *)multiInputView cancelRecordAudio:(UIButton *)audioButton;

- (NSInteger)bxNumberOfMoreChoicesItems:(BXMessagesMultiInputView *)multiInputView;
- (BXMessagesInputMoreChoiceItem *)bxQuickMessagesMultiInputView:(BXMessagesMultiInputView *)multiInputView moreChoicesItemAtIndex:(NSUInteger)index;

@end

/**
 *  Input part of Messages UIKit, including toolbar and accessory view. 
 *
 *  Toolbar can display audio/keyboard exchange button, audio record button, text view,
 *  emoji/keyboard exchange button, accessory button and more customable views.
 *
 *  Accessory view can display more features. Quick Kit provides you a simple grid features
 *  view and an emoji input view. If you want more unique views, you can subclass `BXMessagesMultiInputView`
 *  and custom UI like this class.
 *
 */
@interface BXQuickMessagesMultiInputView : BXMessagesMultiInputView

@property (strong, nonatomic, readonly) BXMessagesInputToolbarButton *audioButton;
@property (strong, nonatomic, readonly) BXMessagesInputToolbarButton *emojiButton;
@property (strong, nonatomic, readonly) BXMessagesInputToolbarButton *accessoryButton;
@property (strong, nonatomic, readonly) BXMessagesInputToolbarButton *keyboardButton;
@property (strong, nonatomic, readonly) BXMessagesInputToolbarTextView *textView;
@property (strong, nonatomic, readonly) BXMessagesInputToolbarAudioButton *audioRecordButton;


@property (weak, nonatomic) id<BXQuickMessagesMultiInputViewDelegate> delegate;

/**
 *  Flag to indicate there's only toolbar visible for view.
 *
 *  NO for showing keyboard, emojiView or accessoryView.
 */
@property (assign, nonatomic) BOOL isOnlyToolbar;

- (void)updateVolumnRate:(CGFloat)volumnRate;

@end
