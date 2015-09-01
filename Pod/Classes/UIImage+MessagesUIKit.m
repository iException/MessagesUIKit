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
    UIImage *image = [self buk_imageNamed:name inBundle:[NSBundle buk_bundle]];
    
    if (!image) {
        image = [self imageNamed:name];
    }
    
    return image;
}

+ (UIImage *)buk_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    return [self buk_imageFromFileWithName:name buble:bundle];
#else
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        return [self buk_imageFromFileWithName:name bundle:bundle];
    }
#endif
}

+ (UIImage *)buk_imageFromFileWithName:(NSString *)name bundle:(NSBundle *)bundle
{
    NSString *imageName = name;
    NSString *type = @"png";
    
    NSArray *components = [imageName componentsSeparatedByString:@"."];
    if (components.count == 2) {
        imageName = [components firstObject];
        type = [components lastObject];
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:imageName ofType:type]];
    
    if (!image || ([[UIScreen mainScreen] scale] == 2.0 && [imageName rangeOfString:@"2x"].location == NSNotFound)) {
        UIImage *retinaImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:[NSString stringWithFormat:@"%@@2x", imageName] ofType:type]];
        if (retinaImage) {
            image = retinaImage;
        }
    }
    
    return image;
}
@end
