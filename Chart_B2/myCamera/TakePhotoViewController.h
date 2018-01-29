//
//  TakePhotoViewController.h
//  MyCamera
//
//  Created by 1224 on 16/6/12.
//  Copyright © 2016年 1224. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CameraPictureDataDelegate <NSObject>

- (void)onImageData:(NSData*)imageData;

@end
typedef NS_ENUM(NSInteger, TakePhotoPosition)
{
    TakePhotoPositionFront = 0,
    TakePhotoPositionBack
};

@interface TakePhotoViewController : UIViewController

@property (nonatomic,assign)TakePhotoPosition position;

@property (nonatomic,assign)BOOL isCancel;

@property (nonatomic,weak)id<CameraPictureDataDelegate>cameraDataDelegate;

- (void)gainPicture;
- (void)takePic;
@end
