//
//  BXMessagesInputCustomizedStickerView.h
//  Pods
//
//  Created by Xiang Li on 10/29/15.
//
//

#import <UIKit/UIKit.h>

// dictionary key for stickersInfo
static NSString *const kStickerCount           = @"BXSticker_count";          // number of stickers in this pack
static NSString *const kStickerPreviewImage    = @"BXSticker_previewImage";   // preview image to be presented in stickersGalleryView
static NSString *const kStickerImages          = @"BXSticker_images";         // images data array

@class BXMessagesInputCustomizedStickerView;

@protocol BXMessagesInputCustomizedStickerViewDelegate <NSObject>

- (void)bxMessagesInputCustomizedStickerView:(BXMessagesInputCustomizedStickerView *)stickerView selectedSticker:(NSDictionary *)stickerInfo;

@end

@interface BXMessagesInputCustomizedStickerView : UIView

@property (nonatomic, weak) id<BXMessagesInputCustomizedStickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource> delegate;

@property (nonatomic, assign) NSUInteger index;

- (instancetype)initWithDelegate:(id)delegate index:(NSUInteger)indexValue;

@end
