//
//  BXMessagesInputMoreChoiceItem.h
//  Baixing
//
//  Created by hyice on 15/3/23.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXMessagesInputMoreChoiceItem : NSObject

@property (copy, nonatomic) NSString *cellNibName;
@property (copy, nonatomic) NSString *cellClassName;
@property (copy, nonatomic) void (^configureBlock)(UICollectionViewCell *cell);
@property (copy, nonatomic) void (^selectBlock)();

@end
