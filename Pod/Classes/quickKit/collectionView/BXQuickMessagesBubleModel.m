//
//  BXQuickMessagesBubleModel.m
//  Baixing
//
//  Created by hyice on 15/3/27.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXQuickMessagesBubleModel.h"
#import "NSBundle+MessagesUIKit.h"
#import "UIImage+MessagesUIKit.h"

@interface BXQuickMessagesBubleModel ()

@end

@implementation BXQuickMessagesBubleModel

+ (BXQuickMessagesBubleModel *)defaultBubleWithTop:(BOOL)top left:(BOOL)left
{
    if (top) {
        if (left) {
            return [self defaultLeftTopBuble];
        }else {
            return [self defaultRightTopBuble];
        }
    }else {
        if (left) {
            return [self defaultLeftBottomBuble];
        }else {
            return [self defaultRightBottomBuble];
        }
    }
}

+ (BXQuickMessagesBubleModel *)defaultLeftTopBuble
{
    BXQuickMessagesBubleModel *buble = [[BXQuickMessagesBubleModel alloc] init];
    
    buble.maskBubleImage = @"weChatBubble_Receiving_Solid";
    buble.defaultMaskColor = [UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:1.0];
    buble.defaultBorderColor = [UIColor colorWithRed:0xcd/255.0 green:0xcb/255.0 blue:0xca/255.0 alpha:1.0];
    buble.resizableCapInsets = UIEdgeInsetsMake(34, 20, 10, 40);
    buble.bubleContentInsets = UIEdgeInsetsMake(13, 21, 13, 16);
    buble.borderWidthInsets = UIEdgeInsetsMake(0.5, 0.7, 0.5, 0.5);
    
    return buble;
}

+ (BXQuickMessagesBubleModel *)defaultLeftBottomBuble
{
    BXQuickMessagesBubleModel *buble = [[BXQuickMessagesBubleModel alloc] init];
    
    buble.maskBubleImage = @"weChatBubble_Receiving_Solid";
    buble.defaultMaskColor = [UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:1.0];
    buble.defaultBorderColor = [UIColor colorWithRed:0xcd/255.0 green:0xcb/255.0 blue:0xca/255.0 alpha:1.0];
    buble.resizableCapInsets = UIEdgeInsetsMake(10, 40, 34, 20);
    buble.bubleContentInsets = UIEdgeInsetsMake(13, 21, 13, 16);
    buble.borderWidthInsets = UIEdgeInsetsMake(0.5, 0.7, 0.5, 0.5);
    
    return buble;
}

+ (BXQuickMessagesBubleModel *)defaultRightTopBuble
{
    BXQuickMessagesBubleModel *buble = [[BXQuickMessagesBubleModel alloc] init];
    
    buble.maskBubleImage = @"weChatBubble_Sending_Solid";
    
    buble.defaultMaskColor = [UIColor colorWithRed:0xa0/255.0 green:0xe7/255.0 blue:0x5a/255.0 alpha:1.0];
    buble.defaultBorderColor = [UIColor colorWithRed:0x83/255.0 green:0xd4/255.0 blue:0x5a/255.0 alpha:1.0];
    buble.resizableCapInsets = UIEdgeInsetsMake(34, 40, 10, 20);
    buble.bubleContentInsets = UIEdgeInsetsMake(13, 16, 13, 21);
    buble.borderWidthInsets = UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.7);
    
    return buble;
}

+ (BXQuickMessagesBubleModel *)defaultRightBottomBuble
{
    BXQuickMessagesBubleModel *buble = [[BXQuickMessagesBubleModel alloc] init];
    buble.maskBubleImage = @"weChatBubble_Sending_Solid";
    buble.defaultMaskColor = [UIColor colorWithRed:0xa0/255.0 green:0xe7/255.0 blue:0x5a/255.0 alpha:1.0];
    buble.defaultBorderColor = [UIColor colorWithRed:0x83/255.0 green:0xd4/255.0 blue:0x5a/255.0 alpha:1.0];
    buble.resizableCapInsets = UIEdgeInsetsMake(10, 40, 34, 20);
    buble.bubleContentInsets = UIEdgeInsetsMake(13, 16, 13, 21);
    buble.borderWidthInsets = UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.7);
    
    return buble;
}

- (UIColor *)currentMaskColor
{
    if (!_currentMaskColor) {
        _currentMaskColor = self.defaultMaskColor;
    }
    
    return _currentMaskColor;
}

- (UIColor *)currentBorderColor
{
    if (!_currentBorderColor) {
        _currentBorderColor = self.defaultBorderColor;
    }
    
    return _currentBorderColor;
}

- (UIImage *)resizableImage
{
    UIImage *image = [UIImage buk_imageNamed:self.maskBubleImage];
    
    image = [self bubleImageFromImage:image maskedWithColor:self.currentMaskColor borderColor:self.currentBorderColor];
    
    return [image resizableImageWithCapInsets:self.resizableCapInsets];
    
    return [self resizableImageWithMaskColor:self.currentMaskColor borderColor:self.currentBorderColor];
}

- (UIImage *)resizableImageWithBorderColor:(UIColor *)borderColor
{
    self.currentBorderColor = borderColor? borderColor : self.currentBorderColor;
    
    return [self resizableImage];
}

- (UIImage *)resizableImageWithMaskColor:(UIColor *)maskColor borderColor:(UIColor *)borderColor
{
    self.currentMaskColor = maskColor? maskColor : self.currentMaskColor;
    self.currentBorderColor = borderColor? borderColor : self.currentBorderColor;
    
    return [self resizableImage];
}

- (UIImage *)bubleImageFromImage:(UIImage *)image maskedWithColor:(UIColor *)maskColor borderColor:(UIColor *)borderColor
{
    NSParameterAssert(maskColor != nil);
    
    CGRect imageRect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, image.scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGContextTranslateCTM(context, 0.0f, -(imageRect.size.height));
        
        CGContextClipToMask(context, imageRect, image.CGImage);
        CGContextSetFillColorWithColor(context, borderColor.CGColor);
        CGContextFillRect(context, imageRect);
        
        CGContextSetFillColorWithColor(context, maskColor.CGColor);
        CGRect contentRect = CGRectMake(imageRect.origin.x + self.borderWidthInsets.left,
                                        imageRect.origin.y + self.borderWidthInsets.top,
                                        imageRect.size.width - self.borderWidthInsets.left - self.borderWidthInsets.right,
                                        imageRect.size.height - self.borderWidthInsets.top - self.borderWidthInsets.bottom);
        CGContextClipToMask(context, contentRect, image.CGImage);
        CGContextFillRect(context, contentRect);
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
