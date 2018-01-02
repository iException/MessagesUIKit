//
//  BXMessagesViewController.h
//  Baixing
//
//  Created by hyice on 15/3/16.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesCollectionView.h"
#import "BXMessagesMultiInputView.h"

@interface BXMessagesViewController : UIViewController

/**
 *  Input part of Messages UIKit. 
 *
 *  If you have subclassed `BXMessagesMultiInputView`, you can redeclare this
 *  property and override the getter method to provide the instance of your
 *  subclass for this property.
 *
 *  To see more details, you can dive into the quick kit.
 */
@property (strong, nonatomic, readonly) BXMessagesMultiInputView *multiInputView;
@property (strong, nonatomic, readonly) UIView *multiInputBackgroundView;

@property (strong, nonatomic, readonly) BXMessagesCollectionView *collectionView;

- (NSInteger)bx_numberOfRowsInCollectionView:(UICollectionView *)collectionView;

- (UICollectionViewCell *)bx_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)bx_collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)bx_registerCellsForCollectionView:(UICollectionView *)collectionView;

- (void)bx_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)hideInputView:(BOOL)hide;

@end
