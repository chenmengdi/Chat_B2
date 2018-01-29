//
//  RecorderView.m
//  Chart_B2
//
//  Created by 朱 广宇 on 2017/9/9.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import "RecorderView.h"

@implementation RecorderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#A9A9A9"];
        self.layer.cornerRadius = 10;
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.width-10, self.height-10)];
    [self addSubview:self.imageView];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i<17; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"VoiceSearchFeedback0%d@2x.png",i]];
        if (image) {
             [imageArray addObject:image];
        }
    }
    self.imageView.animationImages = imageArray;
    self.imageView.animationRepeatCount = 0;
    self.imageView.animationDuration = imageArray.count*0.7;
    
}
- (void)startAnimation{

    [self.imageView startAnimating];
}

- (void)stopAnimation{

    [self.imageView stopAnimating];
    self.hidden = YES;
}
@end
