//
//  MoreFeatureCollectionViewCell.m
//  Chart_B2
//
//  Created by 朱 广宇 on 2017/9/8.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import "MoreFeatureCollectionViewCell.h"

@implementation MoreFeatureCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpView];
    }
    return self;
}
- (void)setUpView{

    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.imageView.layer.cornerRadius = 10;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.imageView];
}
@end
