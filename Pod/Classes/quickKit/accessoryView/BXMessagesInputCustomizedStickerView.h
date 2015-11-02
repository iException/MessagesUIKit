//
//  BXMessagesInputCustomizedStickerView.h
//  Pods
//
//  Created by Xiang Li on 10/29/15.
//
//

#import <UIKit/UIKit.h>

@class BXMessagesInputCustomizedStickerView;

@protocol BXMessagesInputCustomizedStickerViewDelegate <NSObject>

- (void)bxMessagesInputCustomizedStickerView:(BXMessagesInputCustomizedStickerView *)stickerView selectedSticker:(NSDictionary *)stickerInfo;

@end

@interface BXMessagesInputCustomizedStickerView : UIView

@property (nonatomic, weak) id<BXMessagesInputCustomizedStickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource> delegate;

@property (nonatomic, assign) NSUInteger index;

- (instancetype)initWithDelegate:(id)delegate index:(NSUInteger)indexValue;

@end
