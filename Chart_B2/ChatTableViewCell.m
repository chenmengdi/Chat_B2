//
//  ChatTableViewCell.m
//  Chart_B2
//
//  Created by 朱 广宇 on 2017/9/4.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "UIView+SDAutoLayout.h"

#define kLabelMargin 20.f
#define kLabelTopMargin 8.f
#define kLabelBottomMargin 20.f

#define kChatCellItemMargin 10.f

#define kChatCellIconImageViewWH 35.f

#define kMaxContainerWidth 220.f
#define kMaxLabelWidth (kMaxContainerWidth - kLabelMargin * 2)

#define kMaxChatImageViewWidth 200.f
#define kMaxChatImageViewHeight 300.f

@interface ChatTableViewCell ()
{
    ChatModel *tapModel;
    NSTimer *timer;
    BOOL isPlay;
}
@property (nonatomic,strong)UIView *containerView;
@property (nonatomic,strong)UIImageView *containerBackgroundImageView;
@end
@implementation ChatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        isPlay = NO;
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    
    self.timeLabel = [UILabel new];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.timeLabel];
    
    self.containerView = [UIView new];
    [self.contentView addSubview:self.containerView];
    
    self.containerBackgroundImageView = [UIImageView new];
    [self.containerView insertSubview:self.containerBackgroundImageView atIndex:0];
    
    self.iconImageView = [UIImageView new];
    self.iconImageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:self.iconImageView];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont systemFontOfSize:16.0];
    self.contentLabel.isAttributedContent = YES;
    [self.containerView addSubview:self.contentLabel];
    
    
//    self.messageImageView = [UIImageView new];
//    self.messageImageView.hidden = YES;
//    [self.containerView addSubview:self.messageImageView];
    self.showPhotoView = [ShowPhotoView new];
    self.showPhotoView.hidden = YES;
    [self.containerView addSubview:self.showPhotoView];
    
    self.masksImageView = [UIImageView new];
    
    self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceButton.adjustsImageWhenHighlighted = YES;
    self.voiceButton.imageView.clipsToBounds = NO;
    self.voiceButton.imageView.contentMode = UIViewContentModeCenter;
    self.voiceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.voiceButton setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying003"] forState:UIControlStateNormal];
    [self.containerView addSubview:self.voiceButton];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i<3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"SenderVoiceNodePlaying00%d",i+1]];
        if (image) {
            [imageArray addObject:image];
        }
        
    }
    self.voiceButton.imageView.animationImages = imageArray;
    self.voiceButton.imageView.animationRepeatCount = 0;
    self.voiceButton.imageView.animationDuration = imageArray.count*0.7;
    
    self.voiceLengthlabel = [UILabel new];
    self.voiceLengthlabel.textColor = [UIColor blackColor];
    self.voiceLengthlabel.contentMode = UIViewContentModeCenter;
    self.voiceLengthlabel.font = [UIFont systemFontOfSize:16];
    self.voiceLengthlabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.voiceLengthlabel];
    
    self.showPhotoView = [ShowPhotoView new];
    [self.containerView addSubview:self.showPhotoView];
    
    [self setupAutoHeightWithBottomView:self.containerView bottomMargin:0];
    self.containerBackgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0)) ;
}

- (void)setChatModel:(ChatModel *)chatModel{

    _chatModel = chatModel;
    self.timeLabel.text = chatModel.time;
    self.iconImageView.image = [UIImage imageNamed:chatModel.iconName];
    self.timeLabel.hidden = chatModel.isHideTime;
    self.contentLabel.text = chatModel.text;
    //设置隐藏显示时间的label
    [self setTime:chatModel];
    
    //设置消息居左边还是居右边
    [self setMessageSendTypeWithModel:chatModel];
    
    //要显示的消息的类型
    [self getMessageType:chatModel];
}

- (void)getMessageType:(ChatModel*)model{
    
    tapModel = [[ChatModel alloc]init];
    tapModel = model;
    
    if (model.receiveMessageType == CCReceiveMessageTypeForText) {
        //只发文字的情况下
        [self.containerView.layer.mask removeFromSuperlayer];
//        self.messageImageView.hidden = YES;
        self.showPhotoView.hidden = YES;
        self.voiceLengthlabel.hidden = YES;
        self.voiceButton.hidden = YES;
        self.containerBackgroundImageView.didFinishAutoLayoutBlock = nil;
        
        self.contentLabel.sd_resetLayout.leftSpaceToView(self.containerView, kLabelMargin).topSpaceToView(self.containerView, kLabelTopMargin).autoHeightRatio(0);//设置label纵向自适应
        
        [self.contentLabel setSingleLineAutoResizeWithMaxWidth:kMaxContainerWidth];//设置label宽度自适应
        
        // container以label为rightView宽度自适应
        [self.containerView setupAutoWidthWithRightView:self.contentLabel rightMargin:kLabelMargin];
        
        // container以label为bottomView高度自适应
        [self.containerView setupAutoHeightWithBottomView:self.contentLabel bottomMargin:kLabelBottomMargin];
        
    }else if (model.receiveMessageType == CCReceiveMessageTypeForImage){
    
        [self.containerView clearAutoWidthSettings];
//        self.messageImageView.hidden = NO;
        self.showPhotoView.hidden = NO;
        self.voiceLengthlabel.hidden = YES;
        self.voiceButton.hidden = YES;
//        self.messageImageView.image = [UIImage imageWithData:model.imageData];
        self.showPhotoView.cc_imageView.image = [UIImage imageWithData:model.imageData];
        // 根据图片的宽高尺寸设置图片约束
        CGFloat standardWidthHeightRatio = kMaxChatImageViewWidth / kMaxChatImageViewHeight;
        CGFloat widthHeightRatio = 0;
        UIImage *image = [UIImage imageWithData:model.imageData];
        CGFloat h = image.size.height;
        CGFloat w = image.size.width;
        
        if (w > kMaxChatImageViewWidth || w > kMaxChatImageViewHeight) {
            
            widthHeightRatio = w / h;
            
            if (widthHeightRatio > standardWidthHeightRatio) {
                w = kMaxChatImageViewWidth;
                h = w * (image.size.height / image.size.width);
            } else {
                h = kMaxChatImageViewHeight;
                w = h * widthHeightRatio;
            }
        }
        
//        self.messageImageView.size_sd = CGSizeMake(w, h);
        self.showPhotoView.size_sd = CGSizeMake(w, h);
        self.showPhotoView.cc_imageView.size_sd = CGSizeMake(w, h);
        self.containerView.sd_layout.widthIs(w).heightIs(h);
        
        // 设置container以messageImageView为bottomView高度自适应
        [self.containerView setupAutoHeightWithBottomView:self.showPhotoView bottomMargin:kChatCellItemMargin];
        
        // container按照maskImageView裁剪
        self.containerView.layer.mask = self.masksImageView.layer;
        
        __weak typeof(self) weakself = self;
        [_containerBackgroundImageView setDidFinishAutoLayoutBlock:^(CGRect frame) {
            // 在_containerBackgroundImageView的frame确定之后设置maskImageView的size等于containerBackgroundImageView的size
            weakself.masksImageView.size_sd = frame.size;
        }];
        
    }else if (model.receiveMessageType == CCReceiveMessageTypeForVoice){
        
        [self.containerView.layer.mask removeFromSuperlayer];
//        self.messageImageView.hidden = YES;
        self.showPhotoView.hidden = YES;
        self.voiceLengthlabel.hidden = NO;
        self.voiceButton.hidden = NO;
        self.containerBackgroundImageView.didFinishAutoLayoutBlock = nil;
        [self.containerView clearAutoWidthSettings];
        
         self.voiceButton.sd_resetLayout.leftSpaceToView(self.containerView, kLabelMargin).topSpaceToView(self.containerView, kLabelTopMargin).widthIs(kScreenWidth/6).heightIs(self.iconImageView.height-10);
        self.voiceLengthlabel.sd_layout.topEqualToView(self.containerView).rightSpaceToView(self.containerView, 5).widthIs(self.voiceButton.width/2).heightIs(self.iconImageView.height);
        // container以label为rightView宽度自适应
        [self.containerView setupAutoWidthWithRightView:self.voiceButton rightMargin:kLabelMargin];
        
        // container以label为bottomView高度自适应
        [self.containerView setupAutoHeightWithBottomView:self.voiceButton bottomMargin:kLabelBottomMargin];
        
        self.voiceLengthlabel.text = [NSString stringWithFormat:@"%@'",model.voiceLength];
        [self.voiceButton addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)action:(UIButton*)sender{
    
    if (isPlay == NO) {
        NSLog(@"播放录音");
        [self.voiceButton.imageView startAnimating];
        [[CCVoiceManager voiceManager] audioPlayer:tapModel.voiceData];
        timer = [NSTimer scheduledTimerWithTimeInterval:[tapModel.voiceLength intValue] target:self selector:@selector(stop) userInfo:nil repeats:NO];
        isPlay = YES;
    }else{
       [self stop];
    }
}
- (void)stop{

    NSLog(@"停止播放录音");
    isPlay = NO;
    [self.voiceButton.imageView stopAnimating];
    [[CCVoiceManager voiceManager].audioPlayer stop];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
- (void)setTime:(ChatModel*)model{

    if (model.isHideTime) {
        self.timeLabel.sd_layout.leftSpaceToView(self.contentView, 5).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 5).heightIs(0);
    }else{
        
        self.timeLabel.sd_layout.leftSpaceToView(self.contentView, 5).topSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 5).heightIs(14);
    }

}
- (void)setMessageSendTypeWithModel:(ChatModel*)model{

    if (model.messgeType == CCMessageTypeSendToOthers) {
      //我发送的消息，设置居右边
        self.iconImageView.sd_resetLayout.rightSpaceToView(self.contentView, kChatCellItemMargin).topSpaceToView(self.timeLabel, kChatCellItemMargin).widthIs(kChatCellIconImageViewWH).heightIs(kChatCellIconImageViewWH);
        self.containerView.sd_resetLayout.topEqualToView(self.iconImageView).rightSpaceToView(self.iconImageView, kChatCellItemMargin);
        self.containerBackgroundImageView.image = [[UIImage imageNamed:@"SenderTextNodeBkg"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];

        self.voiceButton.transform = CGAffineTransformIdentity;
        
    }else if (model.messgeType == CCMessageTypeSendToMe){
    
        //我收到的消息，居左边
        self.iconImageView.sd_resetLayout.leftSpaceToView(self.contentView, kChatCellItemMargin).topSpaceToView(self.timeLabel, kChatCellItemMargin).widthIs(kChatCellIconImageViewWH).heightIs(kChatCellIconImageViewWH);
        
        self.containerView.sd_resetLayout.topEqualToView(self.iconImageView).leftSpaceToView(self.iconImageView, kChatCellItemMargin);
        
        self.containerBackgroundImageView.image = [[UIImage imageNamed:@"ReceiverAppNodeBkg_HL"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
        
        self.voiceButton.transform = CGAffineTransformMakeRotation(180*M_PI/180);
    }
    self.masksImageView.image = self.containerBackgroundImageView.image;
}

@end
