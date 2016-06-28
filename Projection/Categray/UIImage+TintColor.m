//
//  UIImage+TintColor.m
//  Projection
//
//  Created by 刘昊 on 16/6/12.
//  Copyright © 2016年 刘昊. All rights reserved.
//

#import "UIImage+TintColor.h"

@implementation UIImage (TintColor)

- (void) imageWithTintColor:(UIColor *)tintColor block:(void(^)(UIImage *))block
{
    [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn block:block];
}

- (void) imageWithGradientTintColor:(UIColor *)tintColor block:(void(^)(UIImage *))block
{
    [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay block:block];
}

- (void) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode block:(void(^)(UIImage *))block
{
    dispatch_queue_t queue = dispatch_queue_create("xuanran", NULL);
    __weak typeof(self) wSelf = self;
    dispatch_async(queue, ^{
        UIImage *tintedImage = nil;
        //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
        UIGraphicsBeginImageContextWithOptions(wSelf.size, NO, 0.0f);
        [tintColor setFill];
        CGRect bounds = CGRectMake(0, 0, wSelf.size.width, wSelf.size.height);
        UIRectFill(bounds);
        
        //Draw the tinted image in context
        [wSelf drawInRect:bounds blendMode:blendMode alpha:1.0f];
        
        if (blendMode != kCGBlendModeDestinationIn) {
            [wSelf drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
        }
        
        tintedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (block) {
            block(tintedImage);
        }
    });
}

@end
