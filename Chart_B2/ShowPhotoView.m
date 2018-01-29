//
//  ShowPhotoView.m
//  Chart_B2
//
//  Created by 陈孟迪 on 2017/9/18.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import "ShowPhotoView.h"
#import "CCPhotoBrowseView.h"

@interface ShowPhotoView ()<CCBrowserPhotoDelegate>

@end
@implementation ShowPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self createUI];
    }
    return self;
}

- (void)createUI{

    self.cc_imageView = [UIImageView new];
    self.cc_imageView.backgroundColor = [UIColor redColor];
    self.cc_imageView.userInteractionEnabled = YES;
    [self addSubview:self.cc_imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    [self.cc_imageView addGestureRecognizer:tap];
}

- (void)tapImageView:(UITapGestureRecognizer *)tap{
    NSLog(@"点击图片");
    CCPhotoBrowseView *photoBrowseView = [[CCPhotoBrowseView alloc]init];
    photoBrowseView.browserPhotoDelegate = self;
    [photoBrowseView show];
}

- (UIImage*)onShowPhotoView:(CCPhotoBrowseView *)browseView{

    UIImage *image = self.cc_imageView.image;
    return image;
}
@end
