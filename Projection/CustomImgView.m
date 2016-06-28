//
//  CustomImgView.m
//  Projection
//
//  Created by 刘昊 on 16/6/20.
//  Copyright © 2016年 刘昊. All rights reserved.
//

#import "CustomImgView.h"

@interface CustomImgView ()

@property (nonatomic,strong) NSMutableArray * colors;                      /**< 渲染的颜色*/

@end

@implementation CustomImgView

- (void)asyncDraw{
    if (self.colors.count) {
        __weak typeof(self) wSelf = self;
        [self.image imageWithGradientTintColor:[self.colors lastObject] block:^(UIImage * image) {
            dispatch_async(dispatch_get_main_queue(), ^{
               wSelf.image = image; 
            });
        }];
    }
}

- (NSMutableArray *)colors {
    if (!_colors) {
        _colors = [NSMutableArray array];
    }
    return _colors;
}

- (void)addColor:(UIColor *)color {
    [self.colors addObject:color];
    [self asyncDraw];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
