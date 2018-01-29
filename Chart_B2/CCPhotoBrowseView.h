//
//  CCPhotoBrowseView.h
//  Chart_B2
//
//  Created by 陈孟迪 on 2017/9/18.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCPhotoBrowseView;

@protocol CCBrowserPhotoDelegate <NSObject>

- (UIImage*)onShowPhotoView:(CCPhotoBrowseView*)browseView;

@end

@interface CCPhotoBrowseView : UIScrollView

@property (nonatomic,strong)UIImageView *browseImageView;

@property (nonatomic,weak) id<CCBrowserPhotoDelegate>browserPhotoDelegate;
- (void)show;
@end
