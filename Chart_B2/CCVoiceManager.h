//
//  CCVoiceManager.h
//  Chart_B2
//
//  Created by 朱 广宇 on 2017/9/8.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface CCVoiceManager : NSObject

//音频录音机
@property (nonatomic,strong)AVAudioRecorder *audioRecorder;

//音频播放器，用于播放录音文件
@property (nonatomic,strong)AVAudioPlayer *audioPlayer;

//录音时长
@property (nonatomic,assign)int length;

+ (instancetype)voiceManager;

- (void)startRecorder;

- (void)stopRecorder;

-(NSString*)getSavePath;

-(void)audioPlayer:(NSData*)data;

- (NSString*)getTime:(NSString*)path;
@end
