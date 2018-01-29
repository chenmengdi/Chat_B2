//
//  CCPhotoBrowseView.m
//  Chart_B2
//
//  Created by 陈孟迪 on 2017/9/18.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import "CCPhotoBrowseView.h"

@interface CCPhotoBrowseView ()<UIScrollViewDelegate>
{
    CGFloat scale;//记录上次手势结束的放大倍数
    CGFloat realScalel;//当前手势应该放大的倍数
}
@end
@implementation CCPhotoBrowseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.delegate = self;
        self.minimumZoomScale = 0.5;
        self.maximumZoomScale = 2;
        self.showsVerticalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        //单击手势返回
        UITapGestureRecognizer *removeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove:)];
        [self addGestureRecognizer:removeTap];
        scale = 1;
        [self createUI];
    }
    return self;
}

- (void)createUI{

    self.browseImageView = [UIImageView new];
    self.browseImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.browseImageView];
    
}

- (void)uploadImage{

    UIImage *image = [self.browserPhotoDelegate onShowPhotoView:self];
    self.browseImageView.image = image;
    CGSize imageSize = image.size;
    CGFloat imageViewH = self.width * (imageSize.height / imageSize.width);
    self.browseImageView.frame = CGRectMake(0, (self.height-imageViewH)/2, self.width, imageViewH);
    
}

- (void)remove:(UIGestureRecognizer*)sender{

    [self removeFromSuperview];
}

- (void)show{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [window addSubview:self];
    [self uploadImage];
}

#pragma mark UIScrollView Delegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{

    CGRect frame = self.browseImageView.frame;
    
    frame.origin.y = (self.height - self.browseImageView.height) > 0 ? (self.height - self.browseImageView.height) * 0.5 : 0;
    frame.origin.x = (self.width - self.browseImageView.width) > 0 ? (self.width - self.browseImageView.width) * 0.5 : 0;
    self.browseImageView.frame = frame;
    NSLog(@"width:%f,height:%f",self.browseImageView.width,self.browseImageView.height);
    self.contentSize = CGSizeMake(self.browseImageView.width, self.browseImageView.height);
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{

    return self.browseImageView;
}
@end
