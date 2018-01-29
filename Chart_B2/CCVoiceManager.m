//
//  CCVoiceManager.m
//  Chart_B2
//
//  Created by 朱 广宇 on 2017/9/8.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import "CCVoiceManager.h"

#define kRecordAudioFile @"myRecord.caf"

@interface CCVoiceManager ()<AVAudioRecorderDelegate>

@end
@implementation CCVoiceManager

+ (instancetype)voiceManager{
    
    static CCVoiceManager *voiceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        voiceManager = [[CCVoiceManager alloc]init];
        
    });
    return voiceManager;
}
/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSString*)getSavePath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:@"myRecord.caf"];
    NSLog(@"file path:%@",urlStr);
    return urlStr;
}
//取得录音文件的设置
- (NSDictionary *)getAudioSetting{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //设置录音格式
    [dic setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dic setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dic setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dic setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dic setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    return dic;
}
/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        NSLog(@"录音");
        //创建录音文件保存路径
        NSString *path =[self getSavePath];
        NSURL *url=[NSURL fileURLWithPath:path];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        
#pragma mark 因为没加这句话，导致在真机上获取录音时长一直为0，坑
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//这个是设置AVAudioSession的category的，如果不设置的话，在模拟器上success是YES,但是在真机上是NO
        
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}
//开始录音
- (void)startRecorder{
    
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
    }
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
    }
}
//停止录音
- (void)stopRecorder{
    
    [self.audioRecorder stop];
}


#pragma mark - 录音机代理方法
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    //    if (![self.audioPlayer isPlaying]) {
    //        [self.audioPlayer play];
    //    }
    NSLog(@"录音完成!");
}

//获取录音时长
- (NSString*)getTime:(NSString*)path{

   NSURL *url=[NSURL fileURLWithPath:path];
    NSLog(@"----path:%@",path);
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:url options:@{AVURLAssetPreferPreciseDurationAndTimingKey: @YES}];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
    NSLog(@"===录音时长：%ld",(long)audioDurationSeconds);
    NSString *time = [NSString stringWithFormat:@"%ld",(long)audioDurationSeconds];
    return time;
}
//播放录音
-(void)audioPlayer:(NSData*)data{

//        NSURL *url=[NSURL fileURLWithPath:path];
      NSLog(@"播放录音");
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];//使用听筒
        NSError *error=nil;
        _audioPlayer=[[AVAudioPlayer alloc]initWithData:data error:&error];
        _audioPlayer.numberOfLoops=0;
        [_audioPlayer prepareToPlay];
    
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
        }
}

-(NSMutableArray *)getFilenamelistfromDirPath:(NSString *)dirPath
{
    NSMutableArray *filenamelist = [[NSMutableArray alloc]init];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:kRecordAudioFile]) {
                
                
            }
        }
    }
    
    return filenamelist;
}

-(BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}

@end
