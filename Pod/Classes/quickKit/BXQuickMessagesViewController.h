//
//  BXQuickMessagesViewController.h
//  Baixing
//
//  Created by hyice on 15/3/22.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesViewController.h"
#import "BXQuickMessagesCollectionView.h"
#import "BXMessagesInputMoreChoiceItem.h"
#import "BXQuickMessagesBaseChatCell.h"
#import "BXQuickMessagesMultiInputView.h"

/**
 *  The BXQuickMessagesViewController class is an abstract class you use to quickly start messaging.
 *  Because it is abstract, you do not use this class directly but instead subclass to perform the 
 *  actual task.
 */
@interface BXQuickMessagesViewController : BXMessagesViewController

@property (strong, nonatomic, readonly) BXQuickMessagesMultiInputView *multiInputView;

@property (copy, nonatomic) NSString *selfId;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (assign, nonatomic) BOOL showLoadMore;

/**
 *  Send Text Or Emoji Text. 
 *
 *  Don't need call super, default do nothing.
 */
- (void)bxSendTextMessage:(NSString *)text;

/**
 *  Send Sticker.
 *
 *  Don't need call super, default do nothing.
 */
- (void)bxSendStickerMessage:(id)stickerInfo;


// Audio part, if you use audio button, don't forget to override these methods.

/**
 *  Start to record audio. You should override this method to perform actual recording action
 *
 *  Don't need call super, default do nothing.
 */
- (void)bxStartRecordAudio;

/**
 *  Finish recording audio. You should override this method to perform actual stop recording action
 *  and other actions such as send audio or tell user audio is too short.
 *
 *  Don't need call super, default do nothing.
 */
- (void)bxFinishRecordAudio;

/**
 *  Cancel recording audio. You should override this method to perform actual cancel recording action.
 *
 *  Don't need call super, default do nothing.
 */
- (void)bxCancelRecordAudio;

/**
 *  Return number of `BXMessagesInputMoreChoiceView` items.
 *
 *  Default returns 3, indicating for picture, camera and location item.
 *
 *  @return number of items, you can subclass and override this method to custom items.
 */
- (NSInteger)bxNumberOfItemsInMoreChoicesView;

/**
 *  item for specified index of `BXMessagesInputMoreChoiceView`.
 *
 *  @param index          start from 0
 *
 *  @return item to display, you can subclass and override this method to custom items.
 */
- (BXMessagesInputMoreChoiceItem *)bxItemForMoreChoicesViewAtIndex:(NSUInteger)index;

- (void)bxPickPhotoFromLibraryButtonPressed;

- (void)bxTakePhotoFromCameraButtonPressed;

- (void)bxSendMyLocationButtonPressed;

- (void)bx_collectionView:(UICollectionView *)collectionView updateUserInfoForItem:(BXQuickMessagesBaseChatCell *)item atIndexPath:(NSIndexPath *)indexPath;
- (NSString *)bx_collectionView:(UICollectionView *)collectionView displayNameForItem:(BXQuickMessagesBaseChatCell *)item atIndexPath:(NSIndexPath *)indexPath;
- (NSString *)bx_collectionView:(UICollectionView *)collectionView displayAvatarForItem:(BXQuickMessagesBaseChatCell *)item atIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)bx_moreCollectionViewDataSourceForLoadMore:(UICollectionView *)collectionView;
- (void)bx_setupUserInfoForCell:(BXQuickMessagesBaseChatCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)bx_collectionView:(UICollectionView *)collectionView didTapAvatarAtIndexPath:(NSIndexPath *)indexPath;

- (void)bx_collectionView:(UICollectionView *)collectionView didTapBubleAtIndexPath:(NSIndexPath *)indexPath;

- (void)bx_collectionView:(UICollectionView *)collectionView didTapResendButtonAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)bx_collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath;

- (UICollectionViewCell *)bx_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
