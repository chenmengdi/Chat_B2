//
//  KeyView.m
//  Chart_B2
//
//  Created by 朱 广宇 on 2017/9/5.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//
//仿微信聊天会话界面使用SDAutoLayout写的一个微信聊天会话界面，可以发送文字、图片、语音，（发送语音还有一点bug）
#import "KeyView.h"
@interface KeyView ()<UITextFieldDelegate>
{
    
}
@end
@implementation KeyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:220 green:220 blue:220 alpha:1.0];
        [self createUI];
    }
    return self;
}

- (void)createUI{

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
    
    self.changeWriteTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changeWriteTypeButton.frame = CGRectMake(20, 10, self.height-15, self.height-15);
    [self.changeWriteTypeButton setBackgroundImage:[UIImage imageNamed:@"chatBar_keyboard@2x.png"] forState:UIControlStateNormal];
    [self.changeWriteTypeButton addTarget:self action:@selector(changeWriteType:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.changeWriteTypeButton];
    
    self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceButton.frame = CGRectMake(self.changeWriteTypeButton.right+20, 10, self.width-(self.height-15)*2-20*4, self.height-20);
    self.voiceButton.layer.cornerRadius = 5;
    self.voiceButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.voiceButton.layer.borderWidth = 1;
    [self.voiceButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.voiceButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    self.voiceButton.backgroundColor = [UIColor whiteColor];
    self.voiceButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.voiceButton.hidden = YES;
    [self addSubview:self.voiceButton];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]init];
    longPressGesture.minimumPressDuration = 1.0;
    [self.voiceButton addGestureRecognizer:longPressGesture];
    [longPressGesture addTarget:self action:@selector(longAction:)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]init];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture addTarget:self action:@selector(longAction:)];
    [self.voiceButton addGestureRecognizer:tapGesture];
    
    self.writeMessageTextView = [[UITextField alloc]initWithFrame:self.voiceButton.frame];
    self.writeMessageTextView.hidden = NO;
    self.writeMessageTextView.delegate = self;
    UIView *leftView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.writeMessageTextView.leftView  = leftView;
    self.writeMessageTextView.leftViewMode = UITextFieldViewModeAlways;
    self.writeMessageTextView.layer.cornerRadius = 5;
    self.writeMessageTextView.layer.borderWidth = 1;
    self.writeMessageTextView.keyboardType = UIKeyboardTypeDefault;
    self.writeMessageTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.writeMessageTextView.layer.borderColor = [UIColor grayColor].CGColor;
    [self addSubview:self.writeMessageTextView];
    [self.writeMessageTextView addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];

//    self.expressionButton = [self settingButton:CGRectMake(self.voiceButton.right+10, 10, self.height-15, self.height-15) Image:[UIImage imageNamed:@"chatBar_face@2x.png"]];
//    [self addSubview:self.expressionButton];
    
    self.moreFeatures = [self settingButton:CGRectMake(self.width-20-(self.height-15), 10, self.height-15, self.height-15) Image:[UIImage imageNamed:@"chatBar_more@2x.png"]];
    [self addSubview:self.moreFeatures];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton.frame = CGRectMake(self.moreFeatures.left-5, 10, self.moreFeatures.width+10, self.height-20);
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.backgroundColor = [UIColor grayColor];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.sendButton.hidden = YES;
    [self addSubview:self.sendButton];
    [self.sendButton addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)longAction:(UILongPressGestureRecognizer*)sender{

    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始按住");
        [self.voiceButton setTitle:@"松开 发送" forState:UIControlStateNormal];
        self.voiceButton.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
        self.recorderBlock(1);
    }else if (sender.state == UIGestureRecognizerStateEnded){
    
        NSLog(@"松手");
         [self.voiceButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        self.recorderBlock(2);
       self.voiceButton.backgroundColor = [UIColor whiteColor];
    }
}
//生成按钮
- (UIButton*)settingButton:(CGRect)rect Image:(UIImage*)image{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    return button;
}
//更换类型，发语音或者打字
- (void)changeWriteType:(UIButton*)sender{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.changeWriteTypeButton setBackgroundImage:[UIImage imageNamed:@"chatBar_record@2x.png"] forState:UIControlStateNormal];
        self.writeMessageTextView.hidden = YES;
        self.voiceButton.hidden = NO;
    }else{
        [self.changeWriteTypeButton setBackgroundImage:[UIImage imageNamed:@"chatBar_keyboard@2x.png"] forState:UIControlStateNormal];
        self.writeMessageTextView.hidden = NO;
        self.voiceButton.hidden = YES;
    }
}
//发送消息
- (void)send:(UIButton*)sender{
    
    [self sendMessage:self.writeMessageTextView.text];
    
}
- (void)textChange:(UITextField*)textField{

    if (textField.text.length>0) {
        self.sendButton.hidden = NO;
        self.moreFeatures.hidden = YES;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    // 当点击键盘的返回键（右下角）时，执行该方法。
    // 一般用来隐藏键盘
    [self sendMessage:textField.text];
    return YES;
}
- (void)sendMessage:(NSString*)text{

    [self.writeMessageTextView resignFirstResponder];
    NSLog(@"你输入的文字：%@",text);
    if (text.length>0) {
        self.messageBlock(text);
    }
     self.writeMessageTextView.text = nil;
    self.sendButton.hidden = YES;
    self.moreFeatures.hidden = NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    NSLog(@"textFieldDidBeginEditing");
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSLog(@"textFieldDidEndEditing");
}

- (void)getMessage:(onMessageBlock)messageBlock{

    self.messageBlock = messageBlock;
}
- (void)onRecorderType:(onRecorderHiddenBlock)recorderBlock{

    self.recorderBlock = recorderBlock;
}
@end
