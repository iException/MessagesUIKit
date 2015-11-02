//
//  BXMessagesInputStickerView.h
//  Pods
//
//  Created by Xiang Li on 10/27/15.
//
//

#import <UIKit/UIKit.h>
#import "BXMessagesInputAccessoryView.h"

// dictionary key for stickersInfo
NSString *const kStickerCount           = @"BXSticker_count";          // number of stickers in this pack
NSString *const kStickerPreviewImage    = @"BXSticker_previewImage";   // preview image to be presented in stickersGalleryView
NSString *const kStickerImages          = @"BXSticker_images";         // images data array

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

@property (weak, nonatomic) id<BXMessagesInputStickerViewDelegate> delegate;

// each element in stickersInfo is a dictionary that stores all necessary info about a sticker pack
@property (strong, nonatomic) NSArray *stickersInfo;

// override this method to customize stickers resources loading
// all information is stored into self.stickersInfo
// the loaded stickers information should conform to key-value defined in BXMessagesInputStickerView.m
- (void)loadStickerRecources;

@end
