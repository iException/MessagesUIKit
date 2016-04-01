//
//  BXQuickMessagesMultiInputView.m
//  Baixing
//
//  Created by hyice on 15/3/22.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXQuickMessagesMultiInputView.h"

#import "BXMessagesInputToolbarButton.h"
#import "BXMessagesInputToolbarTextView.h"
#import "BXMessagesInputToolbarAudioButton.h"

#import "BXMessagesInputMoreChoicesView.h"
#import "BXCollectionViewPageableFlowLayout.h"
#import "BXMessagesInputMoreChoiceCell.h"
#import "BXMessagesInputStickerView.h"


typedef NS_ENUM(NSInteger, BXMessagesKeyboardExchangePlace) {
    BXMessagesKeyboardExchangePlace_None,
    BXMessagesKeyboardExchangePlace_Audio,
    BXMessagesKeyboardExchangePlace_Emoji
};

@interface BXQuickMessagesMultiInputView() <UITextViewDelegate, BXMessagesInputStickerViewDelegate, BXMessagesInputToolbarAudioButtonDelegate, BXMessagesInputMoreChoicesViewDelegate>

@property (strong, nonatomic) BXMessagesInputToolbarButton *audioButton;
@property (strong, nonatomic) BXMessagesInputToolbarButton *emojiButton;
@property (strong, nonatomic) BXMessagesInputToolbarButton *accessoryButton;
@property (strong, nonatomic) BXMessagesInputToolbarButton *keyboardButton;
@property (strong, nonatomic) BXMessagesInputToolbarTextView *textView;
@property (strong, nonatomic) BXMessagesInputToolbarAudioButton *audioRecordButton;
@property (assign, nonatomic) BXMessagesKeyboardExchangePlace keyboardButtonPlace;

@property (strong, nonatomic) BXMessagesInputMoreChoicesView *moreChoicesAccessoryView;
@property (strong, nonatomic) BXMessagesInputStickerView *inputStickerView;

@end

@implementation BXQuickMessagesMultiInputView

- (void)setupInputToolbarItems
{
    self.keyboardButtonPlace = BXMessagesKeyboardExchangePlace_None;
    
    [self.inputToolbar addToolbarItem:self.audioButton];
    [self.inputToolbar addToolbarItem:self.textView];
    [self.inputToolbar addToolbarItem:self.emojiButton];
    [self.inputToolbar addToolbarItem:self.accessoryButton];
}

- (void)setupDefaultAccessoryItem
{
    [self.accessoryView displayAccessoryItem:self.moreChoicesAccessoryView animated:YES];
}

- (void)showAccessoryView:(BOOL)show animated:(BOOL)animated
{
    if (!show) {
        if (self.isOnlyToolbar) {
            return;
        }
        
        if (self.keyboardButtonPlace == BXMessagesKeyboardExchangePlace_Emoji) {
            [self changeKeyboardButtonBack];
        }
        
        [self.textView.textView resignFirstResponder];
    }
    
    [super showAccessoryView:show animated:animated];
    
    self.isOnlyToolbar = !show;
}

#pragma mark - tool bar items

- (BXMessagesInputToolbarButton *)audioButton
{
    if (!_audioButton) {
        _audioButton = [BXMessagesInputToolbarButton buttonWithNormalImage:@"buk-toolbar-audio" target:self selector:@selector(audioButtonPressed:)];
    }
    
    return _audioButton;
}

- (void)audioButtonPressed:(UIButton *)btn
{
    [self changeKeyboardButtonBack];
    
    self.keyboardButtonPlace = BXMessagesKeyboardExchangePlace_Audio;
    [self.inputToolbar replaceToolbarItem:self.audioButton withItem:self.keyboardButton];
    [self.inputToolbar replaceToolbarItem:self.textView withItem:self.audioRecordButton];
    
    [self showAccessoryView:NO animated:YES];
}

- (BXMessagesInputToolbarButton *)keyboardButton
{
    if (!_keyboardButton) {
        _keyboardButton = [BXMessagesInputToolbarButton buttonWithNormalImage:@"buk-toolbar-keyboard" target:self selector:@selector(keyboardButtonPressed:)];
    }
    
    return _keyboardButton;
}

- (void)keyboardButtonPressed:(UIButton *)btn
{
    [self changeKeyboardButtonBack];
    
    [self.textView.textView becomeFirstResponder];
}

- (void)changeKeyboardButtonBack
{
    switch (self.keyboardButtonPlace) {
        case BXMessagesKeyboardExchangePlace_Audio:
            [self.inputToolbar replaceToolbarItem:self.keyboardButton withItem:self.audioButton];
            [self.inputToolbar replaceToolbarItem:self.audioRecordButton withItem:self.textView];
            CGFloat offset = self.textView.textView.contentSize.height - CGRectGetHeight(self.textView.textView.bounds);
            self.textView.textView.contentOffset = CGPointMake(0.0f, offset < 0? offset/2.0 : offset);
            break;
            
        case BXMessagesKeyboardExchangePlace_Emoji:
            [self.inputToolbar replaceToolbarItem:self.keyboardButton withItem:self.emojiButton];
            break;
            
        default:
            break;
    }
    
    self.keyboardButtonPlace = BXMessagesKeyboardExchangePlace_None;
}

- (BXMessagesInputToolbarButton *)emojiButton
{
    if (!_emojiButton) {
        _emojiButton = [BXMessagesInputToolbarButton buttonWithNormalImage:@"buk-toolbar-emoji" target:self selector:@selector(emojiButtonPressed:)];
    }
    
    return _emojiButton;
}

- (void)emojiButtonPressed:(UIButton *)btn
{
    [self changeKeyboardButtonBack];
    
    self.keyboardButtonPlace = BXMessagesKeyboardExchangePlace_Emoji;
    [self.inputToolbar replaceToolbarItem:self.emojiButton withItem:self.keyboardButton];
    
    if ([self.textView.textView isFirstResponder]) {
        [self showAccessoryView:YES animated:NO];
        [self.textView.textView resignFirstResponder];
    }else {
        [self showAccessoryView:YES animated:YES];
    }
    
    [self.accessoryView displayAccessoryItem:self.inputStickerView animated:YES];
}

- (BXMessagesInputToolbarButton *)accessoryButton
{
    if (!_accessoryButton) {
        _accessoryButton = [BXMessagesInputToolbarButton buttonWithNormalImage:@"buk-toolbar-more" target:self selector:@selector(accessoryButtonPressed:)];
    }
    
    return _accessoryButton;
}

- (void)accessoryButtonPressed:(UIButton *)btn
{
    [self changeKeyboardButtonBack];
    
    if ([self.textView.textView isFirstResponder]) {
        [self showAccessoryView:YES animated:NO];
        [self.accessoryView removeAccessoryItem:self.inputStickerView animated:NO];
        [self.textView.textView resignFirstResponder];
    }else if (self.isShowingAccessoryView) {
        if (self.isShowingEmojiView) {
            [self.accessoryView removeAccessoryItem:self.inputStickerView animated:YES];
        }else {
            [self.textView.textView becomeFirstResponder];
        }
    }else {
        [self.accessoryView removeAccessoryItem:self.inputStickerView animated:YES];
        
        [self showAccessoryView:YES animated:YES];
    }
}

- (BXMessagesInputToolbarTextView *)textView
{
    if (!_textView) {
        _textView = [[BXMessagesInputToolbarTextView alloc] init];
        _textView.textView.delegate = self;
    }
    
    return _textView;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self changeKeyboardButtonBack];
    
    if (self.isShowingEmojiView) {
        [self.accessoryView removeAccessoryItem:self.inputStickerView animated:NO];
    }
    
    self.isOnlyToolbar = NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (textView.text.length != 0) {
            [self sendText];
        }
        return NO;
    }
    
    return YES;
}

- (void)sendText
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxQuickMessagesMultiInputView:sendText:)]) {
        [self.delegate bxQuickMessagesMultiInputView:self sendText:self.textView.textView.text];
    }
    
    self.textView.textView.text = @"";
}

- (BXMessagesInputToolbarAudioButton *)audioRecordButton
{
    if (!_audioRecordButton) {
        _audioRecordButton = [[BXMessagesInputToolbarAudioButton alloc] init];
        _audioRecordButton.delegate = self;
    }
    
    return _audioRecordButton;
}

- (void)updateVolumnRate:(CGFloat)volumnRate
{
    [self.audioRecordButton updateVolumnRate:volumnRate];
}

#pragma mark - audio record delegate
- (void)bxMessagesAudioButtonStartRecord:(BXMessagesInputToolbarAudioButton *)audioButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxQuickMessagesMultiInputView:startRecordAudio:)]) {
        [self.delegate bxQuickMessagesMultiInputView:self startRecordAudio:audioButton];
    }
}

- (void)bxMessagesAudioButtonFinishRecord:(BXMessagesInputToolbarAudioButton *)audioButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxQuickMessagesMultiInputView:finishRecordAudio:)]) {
        [self.delegate bxQuickMessagesMultiInputView:self finishRecordAudio:audioButton];
    }
}

- (void)bxMessagesAudioButtonCancelRecord:(BXMessagesInputToolbarAudioButton *)audioButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxQuickMessagesMultiInputView:cancelRecordAudio:)]) {
        [self.delegate bxQuickMessagesMultiInputView:self cancelRecordAudio:audioButton];
    }
}

#pragma mark - more choices accessory view
- (BXMessagesInputMoreChoicesView *)moreChoicesAccessoryView
{
    if (!_moreChoicesAccessoryView) {
        _moreChoicesAccessoryView = [[BXMessagesInputMoreChoicesView alloc] init];
        _moreChoicesAccessoryView.delegate = self;
    }
    
    return _moreChoicesAccessoryView;
}

- (NSInteger)numberOfItemsInMoreChoicesView:(BXMessagesInputMoreChoicesView *)moreChoicesView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxNumberOfMoreChoicesItems:)]) {
        return [self.delegate bxNumberOfMoreChoicesItems:self];
    }
    
    return 0;
}

- (BXMessagesInputMoreChoiceItem *)moreChoicesView:(BXMessagesInputMoreChoicesView *)moreChoicesView choiceItemForIndex:(NSUInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxQuickMessagesMultiInputView:moreChoicesItemAtIndex:)]) {
        return [self.delegate bxQuickMessagesMultiInputView:self moreChoicesItemAtIndex:index];
    }
    
    return nil;
}

#pragma mark - inputStickerView & BXMessagesInputStickerViewDelegate
- (BXMessagesInputStickerView *)inputStickerView
{
    if (!_inputStickerView) {
        _inputStickerView = [[BXMessagesInputStickerView alloc] init];
        _inputStickerView.delegate = self;
    }
    
    return _inputStickerView;
}

- (BOOL)isShowingEmojiView
{
    return self.inputStickerView.superview != nil;
}


- (void)bxMessagesInputStickerView:(BXMessagesInputStickerView *)stickerView selectedEmoji:(NSString *)emoji
{
    self.textView.textView.text = [NSString stringWithFormat:@"%@%@", self.textView.textView.text, emoji];
}

- (void)bxMessagesInputStickerView:(BXMessagesInputStickerView *)stickerView selectedSticker:(id)stickerInfo
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxQuickMessagesMultiInputView:sendSticker:)]) {
        [self.delegate bxQuickMessagesMultiInputView:self sendSticker:stickerInfo];
    }
}

- (void)bxMessagesInputStickerView:(BXMessagesInputStickerView *)stickerView sendButtonPressed:(UIButton *)sendButton
{
    if (self.textView.textView.text.length != 0) {
        [self sendText];
    }
}

- (void)bxMessagesInputStickerView:(BXMessagesInputStickerView *)stickerView deleteButtonPressed:(UIButton *)deleteButton
{
    [self.textView.textView deleteBackward];
}

@end
