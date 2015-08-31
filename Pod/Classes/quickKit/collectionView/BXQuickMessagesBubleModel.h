//
//  BXQuickMessagesBubleModel.h
//  Baixing
//
//  Created by hyice on 15/3/27.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXQuickMessagesBubleModel : NSObject

@property (copy, nonatomic) NSString *maskBubleImage;
@property (assign, nonatomic) UIEdgeInsets resizableCapInsets;
@property (assign, nonatomic) UIEdgeInsets bubleContentInsets;
@property (assign, nonatomic) UIEdgeInsets borderWidthInsets;

@property (strong, nonatomic) UIColor *defaultMaskColor;
@property (strong, nonatomic) UIColor *defaultBorderColor;

@property (strong, nonatomic) UIColor *currentMaskColor;
@property (strong, nonatomic) UIColor *currentBorderColor;

@property (strong, nonatomic) UIColor *defaultTextColor;

+ (BXQuickMessagesBubleModel *)defaultBubleWithTop:(BOOL)top left:(BOOL)left;

- (UIImage *)resizableImage;
- (UIImage *)resizableImageWithBorderColor:(UIColor *)borderColor;
- (UIImage *)resizableImageWithMaskColor:(UIColor *)maskColor borderColor:(UIColor *)borderColor;

@end
