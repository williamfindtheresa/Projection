//
//  EditImageViewController.h
//  Projection
//
//  Created by 刘昊 on 16/6/17.
//  Copyright © 2016年 刘昊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditImageViewController : UIViewController

@property (nonatomic,strong) UIImage * oriImage;                        /**< 原始图片*/

@property (nonatomic,copy) void(^editBlock)(UIColor *);                 /**< 回调*/

@end

@protocol RGBSliderDelegate <NSObject>

- (void)rgbDidChanged:(UIColor *)color;

@end

@interface RGBSliderView : UIView

@property (nonatomic,assign) id<RGBSliderDelegate> rgbDelegate;                      /**< 代理*/

@end
