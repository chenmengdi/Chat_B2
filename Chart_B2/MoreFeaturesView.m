//
//  MoreFeaturesView.m
//  Chart_B2
//
//  Created by 朱 广宇 on 2017/9/7.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import "MoreFeaturesView.h"
#import "MoreFeatureCollectionViewCell.h"
#define CELL_ID @"MoreFeatureCollectionViewCell"
@interface MoreFeaturesView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
@implementation MoreFeaturesView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = @[@"相册",@"位置",@"相机",@"电话",@"视频"];
        self.imageArray = [array mutableCopy];
        self.backgroundColor = [UIColor darkGrayColor];
        [self createUI];
    }
    return self;
}
- (NSMutableArray*)imageArray{

    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (void)createUI{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((self.width-25*5)/4, (self.width-25*5)/4);
    layout.minimumLineSpacing = (self.width-self.width/8*4)/5;
    layout.minimumInteritemSpacing = 10;
    
    self.myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:layout];
    self.myCollectionView.backgroundColor = [UIColor darkGrayColor];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    [self addSubview:self.myCollectionView];
    
     [self.myCollectionView registerClass:[MoreFeatureCollectionViewCell class] forCellWithReuseIdentifier:CELL_ID];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.imageArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    MoreFeatureCollectionViewCell * cell = (MoreFeatureCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.width-25*5)/4, (self.width-25*5)/4);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 25, 5, 25);
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    NSLog(@"indexPath.row:%ld",(long)indexPath.row);
    self.chooseBlock(indexPath.row);
}
- (void)onChoose:(chooseViewBlock)chooseBlock{

    self.chooseBlock = chooseBlock;
}
@end
