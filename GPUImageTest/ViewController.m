//
//  ViewController.m
//  GPUImageTest
//
//  Created by wdyzmx on 2020/5/29.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"

@interface ViewController ()
@property (nonatomic, strong) UIImage *tmpImage;
@property (nonatomic, strong) UIImageView *tmpImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIImage *inputImage = [UIImage imageNamed:@"WID-small.jpg"];
    self.tmpImage = [self sketchFilterImageFromOriginImage:inputImage];
    
    [self.view addSubview:({
        self.tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * inputImage.size.height / inputImage.size.width)];
        self.tmpImageView.center = self.view.center;
        self.tmpImageView.image = inputImage;
        self.tmpImageView;
    })];
    
    [self.view addSubview:({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 100 / 2, CGRectGetMaxY(self.tmpImageView.frame) + 20, 100, 50)];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"原 图" forState:UIControlStateNormal];
        [button setTitle:@"黑 白" forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
    
    // Do any additional setup after loading the view.
}

- (void)buttonAction:(UIButton *)btn {
    if (btn.selected) {
        btn.selected = NO;
        self.tmpImageView.image = [UIImage imageNamed:@"WID-small.jpg"];;
    } else {
        btn.selected = YES;
        self.tmpImageView.image = self.tmpImage;
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.tmpImageView.image = self.tmpImage;
//}

#pragma mark - 素描滤镜
- (UIImage *)sketchFilterImageFromOriginImage:(UIImage *)originImage {
    // 使用黑白素描滤镜
    GPUImageSketchFilter *filter = [[GPUImageSketchFilter alloc] init];
    // 设置要渲染的区域
    [filter forceProcessingAtSize:originImage.size];
    [filter useNextFrameForImageCapture];
    // 获取数据源
    GPUImagePicture *stillPic = [[GPUImagePicture alloc] initWithImage:originImage];
    // 添加滤镜
    [stillPic addTarget:filter];
    // 开始渲染
    [stillPic processImage];
    // 获取渲染后的图片
    UIImage *outputImage = [filter imageFromCurrentFramebuffer];
    return outputImage;
}

@end
