//
//  CustomCollectionViewCell.m
//  Projection
//
//  Created by 刘昊 on 16/6/16.
//  Copyright © 2016年 刘昊. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgV];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat wid = CGRectGetWidth(self.frame);
    self.imgV.frame = CGRectMake(0, 0, wid, wid);
}

- (UIImageView *)imgV {
    if (!_imgV) {
        CGFloat wid = CGRectGetWidth(self.frame);
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wid, wid)];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgV;
}

@end
