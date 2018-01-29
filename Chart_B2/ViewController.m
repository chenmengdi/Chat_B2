//
//  ViewController.m
//  Chart_B2
//
//  Created by 朱 广宇 on 2017/9/4.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

#import "ViewController.h"
#import "ChatTableViewCell.h"
#import "ChatModel.h"
#import "KeyView.h"
#import "RecorderView.h"
#import "MoreFeaturesView.h"
#import <Photos/Photos.h>
#import "TakePhotoViewController.h"
#import "UITextView+YZEmotion.h"
#define kChatTableViewCellId @"ChatTableViewCell"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CameraPictureDataDelegate>
{
    UITableView *myTableView;
    KeyView *keyView;
    MoreFeaturesView *moreFeaturesView;
    RecorderView *recorderView;
    BOOL isHiddenMoreFeaturesView;//如果正在输入文字，那么右边显示的是发送的按钮，否则显示的就是+号的按钮
    TakePhotoViewController *takePhoto;
}
@property (nonatomic,strong)NSMutableArray *messageArray;
@property (nonatomic,strong)UIImagePickerController *picker_photo;
@property (strong, nonatomic) YZEmotionKeyboard *emotionKeyboard;
@property (nonatomic,strong)ShowReturnView *showReturnView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    isHiddenMoreFeaturesView = YES;
    [self setUpData];
    [self createUI];
   
    //监听键盘通知（系统自带的通知）
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];//即将弹出键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];//即将退出键盘通知
}

-(NSMutableArray *)messageArray{
    if (!_messageArray) {
        _messageArray  = [NSMutableArray array];
    }
    
    return _messageArray;
}
- (ShowReturnView *)showReturnView{
    
    if (_showReturnView == nil) {
        _showReturnView = [[ShowReturnView alloc]initWithFrame:CGRectMake((kScreenWidth-100)/2, kScreenHeight*3/4, 100, 35)];
    }
    return _showReturnView;
}
// 懒加载键盘
- (YZEmotionKeyboard *)emotionKeyboard
{
    // 创建表情键盘
    if (_emotionKeyboard == nil) {
        
        YZEmotionKeyboard *emotionKeyboard = [YZEmotionKeyboard emotionKeyboard];
        
        emotionKeyboard.sendContent = ^(NSString *content){
            // 点击发送会调用，自动把文本框内容返回给你
        };
        
        _emotionKeyboard = emotionKeyboard;
    }
    return _emotionKeyboard;
}

- (void)setUpData{

    //获取路径
    NSString *path = [[NSBundle mainBundle]pathForResource:@"messages.plist" ofType:nil];
    //取出数据数组
    NSArray *array =  [NSArray arrayWithContentsOfFile:path];
    //便利数组 取出每条消息的数据
    NSLog(@"array:%@",array);
    ChatModel *backModel = nil;
    for (int i = 0; i<array.count; i++) {
        NSDictionary *dic = array[i];
        ChatModel *model = [self changeModel:dic];
        model.hideTime = [model.time isEqualToString:backModel.time];
        backModel = model;
        [self.messageArray addObject:model];
    }
}
- (ChatModel *)changeModel:(NSDictionary*)d{

    ChatModel *model = [ChatModel new];
    model.messgeType = [d[@"type"] intValue];
    model.time = d[@"time"];
    if (model.messgeType == 0) {
        model.iconName = @"icon2.jpg";
    }else{
        model.iconName = @"icon0.jpg";
    }
    if ([d[@"messageType"] isEqualToString:@"0"]) {
        NSLog(@"显示的文字");
        model.receiveMessageType = 2;
        model.text = d[@"text"];
    }else if ([d[@"messageType"] isEqualToString:@"1"]){
        NSLog(@"显示的图片");
        model.receiveMessageType = 3;
        model.imageData = d[@"image"];
    }else if ([d[@"messageType"] isEqualToString:@"2"]){
        NSLog(@"显示的语音");
        model.receiveMessageType = 4;
//        model.voiceFileName = d[@"voice"];
        model.voiceData = d[@"voice"];
        model.voiceLength = d[@"length"];
    }
    
    return model;
}
- (void)createUI{

    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-50) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[ChatTableViewCell class] forCellReuseIdentifier:kChatTableViewCellId];
    
    [self moveToTheBottom];
    keyView = [[KeyView alloc]initWithFrame:CGRectMake(0, myTableView.bottom, kScreenWidth, 50)];
    [self.view addSubview:keyView];
    [keyView.moreFeatures addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    
    moreFeaturesView = [[MoreFeaturesView alloc]initWithFrame:CGRectMake(0, self.view.height-self.view.height*2/3, self.view.width, self.view.height/3)];
    moreFeaturesView.hidden = YES;
    [self.view addSubview:moreFeaturesView];
    
    recorderView = [[RecorderView alloc]initWithFrame:CGRectMake(self.view.width/3, self.view.height/2, self.view.width/3, self.view.width/3)];
    recorderView.hidden = YES;
    [self.view addSubview:recorderView];
    
    [self sendTextMessage];
    [self chooseFeatures];
    [self getRecorderType];
}
//选择按住说话的状态的回调
- (void)getRecorderType{

    [keyView onRecorderType:^(NSInteger recorderType) {
        recorderView.hidden = NO;
        if (recorderType == 1) {
            NSLog(@"开始录音");
            [recorderView startAnimation];
            [[CCVoiceManager voiceManager] startRecorder];
            NSLog(@"===时长：%f",[CCVoiceManager voiceManager].audioRecorder.currentTime);
        }else if (recorderType == 2){
            NSLog(@"结束录音");
            [recorderView stopAnimation];
            [[CCVoiceManager voiceManager] stopRecorder];
            NSString *path = [[CCVoiceManager voiceManager] getSavePath];
            NSData *data = [NSData dataWithContentsOfFile:path];
            NSLog(@"==path:%@",path);
            NSLog(@"时长：%f",[CCVoiceManager voiceManager].audioRecorder.currentTime);
            NSString *timeLength = [[CCVoiceManager voiceManager] getTime:path];
            if ([timeLength isEqualToString:@"0"]) {
               self.showReturnView.titleLabel.text = @"录音失败";
                [self.view addSubview:self.showReturnView];
                [self.showReturnView show];
            }else{
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"text",[AllCommonMethods getNowM_Date],@"time",@"0",@"type",@"",@"image",@"2",@"messageType",data,@"voice",[[CCVoiceManager voiceManager] getTime:path],@"length", nil];
            ChatModel *lastModel = [self.messageArray lastObject];
            ChatModel *model = [self changeModel:dic];
            model.hideTime = [model.time isEqualToString:lastModel.time];
            [self.messageArray addObject:model];
            [myTableView reloadData];
            [self moveToTheBottom];
            [self.view setNeedsLayout];
            }
        }
    }];
}
//选择更多功能的回调
- (void)chooseFeatures{

    [moreFeaturesView onChoose:^(NSInteger index) {
        if (index == 0) {
            [self getLocalImage];
        }else if (index == 2){
            [self getCamera];
        }
    }];
 
}

//要发送的文字的回调
- (void)sendTextMessage{

    [keyView getMessage:^(NSString *text) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:text,@"text",[AllCommonMethods getNowM_Date],@"time",@"0",@"type",@"",@"image",@"0",@"messageType",@"",@"voice",@"",@"length", nil];
        ChatModel *lastModel = [self.messageArray lastObject];
        ChatModel *model = [self changeModel:dic];
        model.hideTime = [model.time isEqualToString:lastModel.time];
        [self.messageArray addObject:model];
        [myTableView reloadData];
        [self moveToTheBottom];
    }];
}
//点击+号
- (void)moreAction{
    
    if (isHiddenMoreFeaturesView == YES) {
        [UIView animateWithDuration:0.5 animations:^{
             [keyView.writeMessageTextView resignFirstResponder];
            myTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-50-self.view.height/3);
            keyView.frame = CGRectMake(0, myTableView.bottom, kScreenWidth, 50);
            moreFeaturesView.frame = CGRectMake(0, keyView.bottom, self.view.width, self.view.height/3);
            moreFeaturesView.hidden = NO;
            isHiddenMoreFeaturesView = NO;
        }];
    }else{
        [self hiddenMoreFeaturesView];
    }
}

#pragma mark  - tableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatTableViewCell *cell = [[ChatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kChatTableViewCellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.chatModel = self.messageArray[indexPath.row];
    
    cell.sd_tableView = tableView;
    cell.sd_indexPath = indexPath;
    
    return  cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatModel *model = self.messageArray[indexPath.row];
    
    return [myTableView cellHeightForIndexPath:indexPath model:model keyPath:@"chatModel" cellClass:[ChatTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
}

- (void)hiddenMoreFeaturesView{

    [UIView animateWithDuration:0.5 animations:^{
        myTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-50);
        keyView.frame = CGRectMake(0, myTableView.bottom, kScreenWidth, 50);
        moreFeaturesView.frame = CGRectMake(0, keyView.bottom, self.view.width, self.view.height/3);
        moreFeaturesView.hidden = YES;
        isHiddenMoreFeaturesView = YES;
    }];

}
//移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)getCamera{

    takePhoto = [[TakePhotoViewController alloc]init];
    takePhoto.cameraDataDelegate = self;
    [self.navigationController pushViewController:takePhoto animated:NO];
}
- (void)onImageData:(NSData *)imageData{

    [self sendImage:imageData];
}
- (void)getLocalImage{
    // 判断是否支持相册
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSLog(@"支持相册");
    } else {
        
        NSLog(@"不支持相册");
    }
    self.picker_photo = [[UIImagePickerController alloc]init];
    self.picker_photo.delegate = self;
    self.picker_photo.allowsEditing = YES;
    self.picker_photo.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.picker_photo animated:YES completion:nil];
    
}
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
        UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
        //要发送的图片
        NSData *imgData = UIImageJPEGRepresentation(image,0);
    [self sendImage:imgData];
}
- (void)sendImage:(NSData*)imageData{

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"text",[AllCommonMethods getNowM_Date],@"time",@"0",@"type",imageData,@"image",@"1",@"messageType",@"",@"voice",@"",@"length",nil];
    ChatModel *lastModel = [self.messageArray lastObject];
    ChatModel *model = [self changeModel:dic];
    model.hideTime = [model.time isEqualToString:lastModel.time];
    [self.messageArray addObject:model];
    [myTableView reloadData];
    [self moveToTheBottom];

}
#pragma mark 滚动到最后一行
- (void)moveToTheBottom{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
    
    [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

#pragma mark   - 键盘通知的响应方法
//键盘弹出的通知方法
-(void)keyboardWillShow:(NSNotification *)note{
    NSLog(@"打开键盘");
    if (isHiddenMoreFeaturesView == NO) {
        [self moreAction];
    }
    //取出弹出键盘的尺寸
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //取出键盘弹出的时间
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        myTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-50-rect.size.height);
        keyView.frame = CGRectMake(0, myTableView.bottom, kScreenWidth, 50);
    }];
    
}
//键盘退出的通知方法123
-(void)keyboardWillHide:(NSNotification *)note{
    NSLog(@"退出键盘");
    //取出键盘弹出的时间
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        myTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-50);
        keyView.frame = CGRectMake(0, myTableView.bottom, kScreenWidth, 50);
    }];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [keyView.writeMessageTextView resignFirstResponder];
    if (moreFeaturesView) {
        [self hiddenMoreFeaturesView];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    if ([[touch view] isEqual:myTableView]) {
        [keyView.writeMessageTextView resignFirstResponder];
    }
}

@end
