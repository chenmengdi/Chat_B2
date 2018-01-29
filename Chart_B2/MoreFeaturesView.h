//
//  MoreFeaturesView.h
//  Chart_B2
//
//  Created by 朱 广宇 on 2017/9/7.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^chooseViewBlock)(NSInteger index);
@interface MoreFeaturesView : UIView

@property (nonatomic,strong)UICollectionView *myCollectionView;

@property (nonatomic,strong)NSMutableArray *imageArray;

@property (nonatomic,strong)chooseViewBlock chooseBlock;

- (void)onChoose:(chooseViewBlock)chooseBlock;

@end
