//
//  EditImageViewController.m
//  Projection
//
//  Created by 刘昊 on 16/6/17.
//  Copyright © 2016年 刘昊. All rights reserved.
//

#import "EditImageViewController.h"

@interface EditImageViewController ()<RGBSliderDelegate>

@property (nonatomic,strong) RGBSliderView * editV;

@end

@implementation EditImageViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //保留之前的控制器画面
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.editV];
    self.view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

#pragma mark -- Action
- (void)tapAction:(UITapGestureRecognizer *)sender {
    CGPoint locationP = [sender locationInView:self.view];
    if (!CGRectContainsPoint(self.editV.frame, locationP)) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark -- 代理(RGBPressDelegate)
- (void)rgbDidChanged:(UIColor *)color {
    if (self.editBlock) {
        self.editBlock(color);
    }
}

#pragma mark -- GetterAndSetter
- (RGBSliderView *)editV {
    if (!_editV) {
        _editV = [[RGBSliderView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 110)];
        _editV.rgbDelegate = self;
    }
    return _editV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


@interface RGBSliderView ()

@property (nonatomic,strong) UISlider * rSliderV;

@property (nonatomic,strong) UISlider * gSliderV;

@property (nonatomic,strong) UISlider * bSliderV;

@end

@implementation RGBSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        for (UIProgressView * pv in @[self.rSliderV,self.gSliderV,self.bSliderV]) {
            [self addSubview:pv];
        }
    }
    return self;
}

#pragma mark -- GetterAndGetter
- (UISlider *)rSliderV {
    if (!_rSliderV) {
        CGRect frame = CGRectMake(20, 0, CGRectGetWidth(self.frame) - 40, 30);
        _rSliderV = [[UISlider alloc] initWithFrame:frame];
        _rSliderV.value = 0.5;
        _rSliderV.tintColor = [UIColor redColor];
        [_rSliderV addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return _rSliderV;
}

- (UISlider *)gSliderV {
    if (!_gSliderV) {
        CGRect frame = CGRectMake(20, CGRectGetMaxY(self.rSliderV.frame) + 10, CGRectGetWidth(self.frame) - 40, 30);
        _gSliderV = [[UISlider alloc] initWithFrame:frame];
        _gSliderV.value = 0.5;
        _gSliderV.tintColor = [UIColor greenColor];
        [_gSliderV addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return _gSliderV;
}

- (UISlider *)bSliderV {
    if (!_bSliderV) {
        CGRect frame = CGRectMake(20, CGRectGetMaxY(self.gSliderV.frame) + 10, CGRectGetWidth(self.frame) - 40, 30);
        _bSliderV = [[UISlider alloc] initWithFrame:frame];
        _bSliderV.value = 0.5;
        [_bSliderV addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return _bSliderV;
}

#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"value"]) {
        UIColor * color = [UIColor colorWithRed:self.rSliderV.value green:self.gSliderV.value blue:self.bSliderV.value alpha:1.f];
        if ([self.rgbDelegate respondsToSelector:@selector(rgbDidChanged:)]) {
            [self.rgbDelegate rgbDidChanged:color];
        }
    }
}

#pragma mark -- 销毁
- (void)dealloc {
    for (UIProgressView * pv in @[_rSliderV,_gSliderV,_bSliderV]) {
        [pv removeObserver:self forKeyPath:@"value"];
    }
}

@end
