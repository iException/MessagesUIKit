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
@class BXMessagesInputCustomizedStickerView;

@protocol BXMessagesInputStickerViewDelegate <NSObject>

- (void)bxMessagesInputStickerView:(BXMessagesInputStickerView *)stickerView selectedEmoji:(NSString *)emoji;
- (void)bxMessagesInputStickerView:(BXMessagesInputStickerView *)stickerView selectedSticker:(id)stickerInfo;
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
- (void)loadStickerResources;

// override following method to customize stickers resouces parsing
- (NSUInteger)getStickerPackCountAtIndex:(NSUInteger)index;
- (UIImage *)getStickerPreviewImageAtIndex:(NSUInteger)index;
- (NSArray *)getStickerImagesAtIndex:(NSUInteger)index;
- (NSInteger)numberOfStickersOfPackAtIndex:(NSInteger)index;
- (UIImage *)imageOfStickersWithPackIndex:(NSInteger)packIndex stickerIndex:(NSInteger)stickerIndex;
- (NSString *)nameOfStickersWithPackIndex:(NSInteger)packIndex stickerIndex:(NSInteger)stickerIndex;
- (void)bxMessagesInputCustomizedStickerView:(BXMessagesInputCustomizedStickerView *)stickerView packIndex:(NSInteger)packIndex stickerIndex:(NSInteger)stickerIndex;

/**
 *  reload UI elements according to newly set self.stickersInfo
 */
- (void)reloadAll;

@end
