//
//  TakePhotoViewController.m
//  MyCamera
//
//  Created by 1224 on 16/6/12.
//  Copyright © 2016年 1224. All rights reserved.
//

#import "TakePhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+borderLine.h"
#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
@interface TakePhotoViewController ()<AVCaptureMetadataOutputObjectsDelegate>

{
     //切换前后摄像头
    UIButton *switchBtn;
    
//    自动
    UIButton *autonBtn;
    
//    拍照
    UIButton *takePicBtn;
    
//    取消
    UIButton *cancelBtn;
    
//    重拍
    UIButton *restartBtn;
    
//    使用拍照
    UIButton *doneBtn;
    UIView *cameraView;
    
//    预览照片
    UIImageView *groupImage;
 
    UIImageView *gainImageView;
    
    NSData * imageData;
    
    }
    @property (nonatomic,strong) AVCaptureSession *session;
    
    @property(nonatomic,strong)AVCaptureDeviceInput *videoInput;
    
    @property (nonatomic,strong)AVCaptureStillImageOutput *stillImageOutput;
    
    @property (nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;



- (void)takePic;

- (void)cancel:(UIButton *)sender;

- (void)done;

- (void)autoAction:(UIButton *)sender;

- (void)switchAction:(UIButton *)sender;

- (void)restartAction;
@end

@implementation TakePhotoViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
   }

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    self.isCancel = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.isCancel forKey:@"isCancel"];
    self.navigationItem.title = @"预览照片";
    self.view.backgroundColor = [UIColor colorWithRed:0.0032 green:0.0032 blue:0.0032 alpha:1.0];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takePhoto:) name:@"BLE_WriteCommand" object:nil];
}
- (void)takePhoto:(NSNotification*)result{

    NSString *str = result.userInfo[@"openCamera"];
    if ([str isEqualToString:@"1"]) {
        [self gainPicture];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self initialSession];
    if (self.session) {
        [self.view.layer addSublayer:self.previewLayer];
        [self.session startRunning];
    }
    
}

- (BOOL)shouldAutorotate{

    return NO;
}
//横屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
}


- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (_previewLayer == nil) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
         _previewLayer.frame = CGRectMake(0, 5, SCREEN_WIDTH, 250+(SCREEN_HEIGHT-100-55)/2);
        }
    return _previewLayer;
        
}

- (void)createUI{
    
    gainImageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    gainImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:gainImageView];
    
    takePicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    takePicBtn.frame = CGRectMake((SCREEN_WIDTH-55)/2, 250+(SCREEN_HEIGHT-100-55)/2, 55, 55);
    [takePicBtn setBackgroundImage:[UIImage imageNamed:@"group2@2x"] forState:UIControlStateNormal];
    [takePicBtn addTarget:self action:@selector(takePic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePicBtn];
    
//    restartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    restartBtn.frame = CGRectMake(10, 250+(SCREEN_HEIGHT-100-55)/2, 55, 60);
//    [restartBtn setTitle:@"重拍" forState:UIControlStateNormal];
//    [restartBtn addTarget:self action:@selector(restartAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:restartBtn];
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 250+(SCREEN_HEIGHT-100-55)/2, 55, 55);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.frame = CGRectMake(SCREEN_WIDTH-50, 30, 40, 40);
    [switchBtn setBackgroundImage:[UIImage imageNamed:@"group1@2x"] forState:UIControlStateNormal];
    [switchBtn setBackgroundImage:[UIImage imageNamed:@"group1@2x"] forState:UIControlStateSelected];
    [switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchBtn];

}


#pragma mark session
- (void) initialSession;
{
    //这个方法的执行我放在init方法里了
    self.session = [[AVCaptureSession alloc] init];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    //[self fronCamera]方法会返回一个AVCaptureDevice对象，因为我初始化时是采用前摄像头，所以这么写，具体的实现方法后面会介绍
    [self.session setSessionPreset:AVCaptureSessionPreset640x480];//
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    if (self.session) {
        [self.session startRunning];
    }
    [self setUpCameraLayer];
    [self setDonePicture:NO];
}
- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:self.position == TakePhotoPositionBack ? AVCaptureDevicePositionBack :AVCaptureDevicePositionFront];
}

#pragma mark VideoCapture
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

- (void) setUpCameraLayer
{
    if (self.previewLayer == nil) {
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        [self.previewLayer setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [cameraView.layer insertSublayer:self.previewLayer below:[[cameraView.layer sublayers] objectAtIndex:0]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 切换前后摄像头
- (void)swapFrontAndBackCameras {
    // Assume the session is already running
    
    NSArray *inputs = self.session.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [self.session beginConfiguration];
            
            [self.session removeInput:input];
            [self.session addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.session commitConfiguration];
            break;
        }
    }
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    if (self.session) {
        [self.session stopRunning];
    }
}
-(void)viewDidLayoutSubviews
{
    
    [takePicBtn cornerRadius:CGRectGetHeight(takePicBtn.frame)/2.0 borderColor:[[UIColor clearColor] CGColor] borderWidth:0];
    [restartBtn cornerRadius:4 borderColor:[[UIColor clearColor] CGColor] borderWidth:0];
    [doneBtn cornerRadius:4 borderColor:[[UIColor clearColor] CGColor] borderWidth:0];
    
    [super viewDidLayoutSubviews];
}
#pragma mark 获取照片
- (void)gainPicture
{
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    if (!videoConnection) {
        NSLog(@"获取照片失败!");
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        if (self.session) {
            [self.session stopRunning];
        }
        
//        ImageViewController *imageVC = [[ImageViewController alloc] initWithImage:[UIImage imageWithData:imageData]];
//        [self presentViewController:imageVC animated:NO completion:nil];
        gainImageView.image = [UIImage imageWithData:imageData];
        [self done];
//        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(go) userInfo:nil repeats:NO];
        [self previewPhoto];
        [self setDonePicture:YES];
        
    }];
}

- (void)previewPhoto{

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"重拍" style:UIBarButtonItemStylePlain target:self action:@selector(go)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(right)];
}
- (void)right{

    [self.cameraDataDelegate onImageData:imageData];
     [self.navigationController popViewControllerAnimated:NO];
    
}
- (void)go{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [self restartAction];

//    [gainImageView removeFromSuperview];
    
}
///拍照之后YES  显示的东西
- (void)setDonePicture:(BOOL)isTake;
{
    self.navigationController.navigationBarHidden = !isTake;
    ///拍照完之后
    self.previewLayer.hidden =  cancelBtn.hidden = autonBtn.hidden = switchBtn.hidden = takePicBtn.hidden = isTake;
    restartBtn.hidden = gainImageView.hidden = doneBtn.hidden = !isTake;
    
}

- (void)takePic{

    [self gainPicture];
    
}

- (void)cancel:(UIButton *)sender{
    
    self.isCancel = YES;
    NSLog(@"离开相机界面%d",self.isCancel);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.isCancel forKey:@"isCancel"];
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)done{

//    if ([_delegate respondsToSelector:@selector(didFinishPickingImage:)]) {
//        [_delegate didFinishPickingImage:gainImageView.image];
//
//    }
//    
//    [self dismissViewControllerAnimated:YES completion:NULL];
    UIImageWriteToSavedPhotosAlbum(gainImageView.image, nil, nil, nil);
}

- (void)autoAction:(UIButton *)sender{

    
    
}

- (void)switchAction:(UIButton *)sender{

    [self swapFrontAndBackCameras];
    sender.selected = !sender.selected;
}

- (void)restartAction{

    [self setDonePicture:NO];
    
    if (self.session) {
        [self.session startRunning];
    }
}







@end
