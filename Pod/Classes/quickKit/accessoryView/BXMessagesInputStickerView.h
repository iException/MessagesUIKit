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
- (void)bxMessagesInputStickerView:(BXMessagesInputStickerView *)stickerView selectedSticker:(NSDictionary *)stickerInfo;
- (void)bxMessagesInputStickerView:(BXMessagesInputStickerView *)stickerView deleteButtonPressed:(UIButton *)deleteButton;
- (void)bxMessagesInputStickerView:(BXMessagesInputStickerView *)stickerView sendButtonPressed:(UIButton *)sendButton;

@end

@interface BXMessagesInputStickerView : UIView <BXMessagesInputAccessoryItem>

@property (assign, nonatomic) BOOL flexibleHeight;

@property (assign, nonatomic) BOOL flexibleWidth;

@property (assign, nonatomic) CGFloat height;

/**
 *  indicating whether the sticker packs can be extended 
 *  and a extention button will be shown in the bottom tool bar
 */
@property (assign, nonatomic) BOOL hasExtention;

@property (strong, nonatomic) UIColor *bottomBarColor;

@property (weak, nonatomic) id<BXMessagesInputStickerViewDelegate> delegate;

// each element in stickersInfo is a dictionary that stores all necessary info about a sticker pack
@property (strong, nonatomic) NSArray *stickersInfo;

// override this method to customize stickers resources loading
// all information is stored into self.stickersInfo
// the loaded stickers information should conform to key-value defined in BXMessagesInputStickerView.m
- (void)loadStickerRecources;

@end
