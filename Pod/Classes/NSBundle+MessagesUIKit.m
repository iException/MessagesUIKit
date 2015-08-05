//
//  NSBundle+MessagesUIKit.m
//  Pods
//
//  Created by hyice on 15/8/5.
//
//

#import "NSBundle+MessagesUIKit.h"
#import "BXMessagesViewController.h"

@implementation NSBundle (MessagesUIKit)

+ (NSBundle *)buk_bundle
{
    NSString *bundlePath = [[NSBundle bundleForClass:[BXMessagesViewController class]] pathForResource:@"MessagesUIKit" ofType:@"bundle"];
    return [NSBundle bundleWithPath:bundlePath];
}

@end
