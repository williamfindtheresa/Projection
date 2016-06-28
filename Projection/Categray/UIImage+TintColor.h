//
//  UIImage+TintColor.h
//  Projection
//
//  Created by 刘昊 on 16/6/12.
//  Copyright © 2016年 刘昊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TintColor)

- (void) imageWithTintColor:(UIColor *)tintColor block:(void(^)(UIImage *))block;
- (void) imageWithGradientTintColor:(UIColor *)tintColor block:(void(^)(UIImage *))block;
- (void) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode block:(void(^)(UIImage *))block;

@end
