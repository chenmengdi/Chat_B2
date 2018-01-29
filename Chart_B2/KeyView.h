//
//  KeyView.h
//  Chart_B2
//
//  Created by 朱 广宇 on 2017/9/5.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^onRecorderHiddenBlock)(NSInteger recorderType);
typedef void(^onMessageBlock)(NSString *text);
@interface KeyView : UIView

@property (nonatomic,strong)UIButton *changeWriteTypeButton;

@property (nonatomic,strong)UIButton *voiceButton;

@property (nonatomic,strong)UITextField *writeMessageTextView;

@property (nonatomic,strong)UIButton *expressionButton;

@property (nonatomic,strong)UIButton *moreFeatures;

@property (nonatomic,strong)UIButton *sendButton;

@property (nonatomic,strong)onMessageBlock messageBlock;

@property (nonatomic,strong)onRecorderHiddenBlock recorderBlock;

- (void)getMessage:(onMessageBlock)messageBlock;

- (void)onRecorderType:(onRecorderHiddenBlock)recorderBlock;
@end
