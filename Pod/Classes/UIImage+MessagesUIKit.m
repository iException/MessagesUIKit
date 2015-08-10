//
//  UIImage+MessagesUIKit.m
//  Pods
//
//  Created by hyice on 15/8/10.
//
//

#import "UIImage+MessagesUIKit.h"
#import "NSBundle+MessagesUIKit.h"

@implementation UIImage (MessagesUIKit)

+ (UIImage *)buk_imageNamed:(NSString *)name
{
    return [self buk_imageNamed:name inBundle:[NSBundle buk_bundle]];
}

+ (UIImage *)buk_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]];
#else
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        return [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]];
    }
#endif
}
@end
