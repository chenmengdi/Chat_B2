//
//  ShowReturnView.h
//  Toolbox
//
//  Created by GUANG YU ZHU on 4/18/17.
//  Copyright © 2017 YKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowReturnView : UIView

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)NSString *returnString;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)show;
@end
