//
//  ViewController.m
//  Projection
//
//  Created by 刘昊 on 16/6/12.
//  Copyright © 2016年 刘昊. All rights reserved.
//

#import "ViewController.h"
#import "EditImageViewController.h"
#import "CustomImgView.h"

#define RGB(R,G,B) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.f]

static CGFloat btnWid = 60;
static CGFloat btnHei = 40;
static CGFloat btnAlpha = 0.5;

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) CustomImgView * imgV;

@property (nonatomic,strong) UIButton * selectBtn;                      /**< 选取按钮*/

@property (nonatomic,strong) UIButton * editBtn;                        /**< 修改*/

@property (nonatomic,strong) UIButton * saveBtn;                        /**< 保存*/

@property (nonatomic,assign) BOOL isFirstLoad;                          /**< 是否是第一次加载*/

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isFirstLoad = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"heiheihei");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isFirstLoad) {
        [self getImagePicker];
    }
}

#pragma mark -- 操作布局
- (void)setUI {
    for (UIButton * btn in @[self.imgV,self.selectBtn,self.editBtn,self.saveBtn]) {
        [self.view addSubview:btn];
    }
}

#pragma mark -- 相册
- (void)getImagePicker {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
        self.isFirstLoad = NO;
    }
}

#pragma mark -- 响应事件
- (void)selectAction:(UIButton *)sender{
    [self getImagePicker];
}
- (void)editAction:(UIButton *)sender{
    EditImageViewController * editVC = [[EditImageViewController alloc] init];
    editVC.oriImage = self.imgV.image;
    __weak typeof(self) wSelf = self;
    editVC.editBlock = ^(UIColor * color){
        [wSelf.imgV addColor:color];
    };
    [self presentViewController:editVC animated:YES completion:nil];
}
- (void)saveAction:(UIButton *)sender{
    UIImageWriteToSavedPhotosAlbum(self.imgV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:nil
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(alertC) wAlert = alertC;
    if (error) {
        alertC.title = @"保存到相册失败啦!";
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"朕知道了" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:okAction];
    }else {
        alertC.title = @"保存成功^_^";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wAlert dismissViewControllerAnimated:YES completion:nil];
        });
    }
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 设置图片
    self.imgV.image = info[UIImagePickerControllerOriginalImage];
}

#pragma mark -- GetterAndSetter
- (CustomImgView *)imgV {
    if (!_imgV) {
        _imgV = [[CustomImgView alloc] initWithFrame:self.view.bounds];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgV;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _selectBtn.frame = CGRectMake((WIDTH / 3.0 - btnWid) / 2.0, HEIGHT - btnHei - 20, btnWid, btnHei);
        _selectBtn.alpha = btnAlpha;
        [_selectBtn setTitle:@"选取" forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _editBtn.frame = CGRectMake(WIDTH / 3.0 + (WIDTH / 3.0 - btnWid) / 2.0, HEIGHT - btnHei - 20, btnWid, btnHei);
        _editBtn.alpha = btnAlpha;
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _saveBtn.frame = CGRectMake(WIDTH*2 / 3.0 + (WIDTH / 3.0 - btnWid) / 2.0, HEIGHT - btnHei - 20, btnWid, btnHei);
        _saveBtn.alpha = btnAlpha;
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
