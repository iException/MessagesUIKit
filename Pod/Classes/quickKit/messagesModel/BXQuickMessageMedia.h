//
//  BXQuickMessageMedia.h
//  Baixing
//
//  Created by hyice on 15/3/30.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BXQuickMessageMedia <NSObject>

- (BOOL)displayWithBubleMask;

- (UIView *)mediaView;

- (CGSize)displaySize;

- (BOOL)displayUnreadBadgeBeforeTap;

- (NSString *)contentDescription;

@optional

/**
 *  Only take effect when @name -displayWithBubleMask returns YES.
 *
 *  @return border color. Return nil for no border.
 */
- (UIColor *)borderColorForBubleMask;

@end
