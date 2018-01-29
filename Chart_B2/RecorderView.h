//
//  RecorderView.h
//  Chart_B2
//
//  Created by 朱 广宇 on 2017/9/9.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecorderView : UIView

@property (nonatomic,strong)UIImageView *imageView;

- (void)startAnimation;

- (void)stopAnimation;
@end
