//
//  BXMessagesInputMoreChoicesView.h
//  Baixing
//
//  Created by hyice on 15/3/19.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXMessagesInputAccessoryView.h"

@class BXMessagesInputMoreChoiceItem;
@class BXMessagesInputMoreChoicesView;

@protocol BXMessagesInputMoreChoicesViewDelegate <NSObject>

- (NSInteger)numberOfItemsInMoreChoicesView:(BXMessagesInputMoreChoicesView *)moreChoicesView;

- (BXMessagesInputMoreChoiceItem *)moreChoicesView:(BXMessagesInputMoreChoicesView *)moreChoicesView
                                choiceItemForIndex:(NSUInteger)index;

@end

@interface BXMessagesInputMoreChoicesView : UIView <BXMessagesInputAccessoryItem>

@property (assign, nonatomic) BOOL flexibleHeight;

@property (assign, nonatomic) BOOL flexibleWidth;

@property (assign, nonatomic) CGFloat height;

@property (strong, nonatomic, readonly) UICollectionView *collectionView;

@property (strong, nonatomic, readonly) UIPageControl *pageControl;

@property (weak, nonatomic) id<BXMessagesInputMoreChoicesViewDelegate> delegate;

@end
