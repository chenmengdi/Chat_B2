//
//  ChatTableViewCell.h
//  Chart_B2
//
//  Created by 朱 广宇 on 2017/9/4.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
#import "ShowPhotoView.h"
@interface ChatTableViewCell : UITableViewCell

@property (nonatomic,strong)ChatModel *chatModel;

//显示时间
@property (nonatomic,strong)UILabel *timeLabel;
//显示头像
@property (nonatomic,strong)UIImageView *iconImageView;
//发的内容（仅是文字）
@property (nonatomic,strong)UILabel *contentLabel;
//发送的图片
@property (nonatomic,strong)UIImageView *messageImageView;

@property (nonatomic,strong)UIImageView *masksImageView;

@property (nonatomic,strong)UIButton *voiceButton;

@property (nonatomic,strong)UILabel *voiceLengthlabel;

@property (nonatomic,strong)ShowPhotoView *showPhotoView;

@end
