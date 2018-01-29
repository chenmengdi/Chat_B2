//
//  ShowReturnView.m
//  Toolbox
//
//  Created by GUANG YU ZHU on 4/18/17.
//  Copyright © 2017 YKH. All rights reserved.
//

#import "ShowReturnView.h"

@interface ShowReturnView ()
{
    NSTimer *timer;
}
@end
@implementation ShowReturnView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 5;
        
        [self show];
    }
    return self;
}
- (void)show{

   timer =  [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(time) userInfo:nil repeats:NO];
}
- (void)time{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    [self removeFromSuperview];
}
- (UILabel*)titleLabel{

    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 1, self.width-2, self.height-2)];
        _titleLabel.text = self.returnString;
        _titleLabel.backgroundColor = [UIColor blackColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.cornerRadius = 5;
        [self addSubview:_titleLabel];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:14];

    }
    return _titleLabel;
}
@end
