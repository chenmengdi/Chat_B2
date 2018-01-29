//
//  ChatModel.h
//  Chart_B2
//
//  Created by 朱 广宇 on 2017/9/4.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CCMessageTypeSendToOthers = 0,//发送给别人的消息
    CCMessageTypeSendToMe //接收的消息
} CCMessageType;

typedef enum : NSUInteger {
    CCReceiveMessageTypeForText = 2,
    CCReceiveMessageTypeForImage,
    CCReceiveMessageTypeForVoice
} CCReceiveMessageType;

@interface ChatModel : NSObject
//消息类型（发送的或者接收的消息）
@property (nonatomic,assign) CCMessageType messgeType;

//接收的消息的类型（文字、图片、语音）
@property (nonatomic,assign) CCReceiveMessageType receiveMessageType;

//消息的时间
@property (nonatomic,strong) NSString *time;

//消息的文字内容
@property (nonatomic,strong) NSString *text;

//头像
@property (nonatomic,strong) NSString *iconName;

//消息的图片内容为NSData类型
@property (nonatomic,strong) NSData *imageData;

//语音消息的路径
//@property (nonatomic,strong) NSString *voiceFileName;

//语音消息
@property (nonatomic,strong) NSData *voiceData;

//语音时长
@property (nonatomic,strong) NSString *voiceLength;

//消息时间如果跟上一条消息时间相同就不显示
@property (nonatomic,assign,getter=isHideTime)BOOL  hideTime;


+(instancetype)messageWithDict:(NSDictionary *)dict;
@end
