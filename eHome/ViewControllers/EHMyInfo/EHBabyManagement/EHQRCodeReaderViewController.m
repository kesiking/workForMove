//
//  EHQRCodeReaderViewController.m
//  eHome
//
//  Created by louzhenhua on 15/7/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHQRCodeReaderViewController.h"
#import <AVFoundation/AVFoundation.h>




@interface EHQRCodeReaderViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    NSInteger num;
    NSTimer * timer;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, strong)UIImageView* lineImageView;
@end

@implementation EHQRCodeReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"扫码二维码";
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(self.view.frame))];
    imageView.image = [UIImage imageNamed:@"scanningthearea"];
    [self.view addSubview:imageView];
    
    num =0;
    _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(72*SCREEN_SCALE, 125*SCREEN_SCALE, CGRectGetWidth([UIScreen mainScreen].bounds) - 2*72*SCREEN_SCALE, 1)];
    _lineImageView.image = [UIImage imageNamed:@"scanningthearea_line"];
    [self.view addSubview:_lineImageView];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
    

}
-(void)lineAnimation
{

    num ++;
    _lineImageView.frame = CGRectMake(72*SCREEN_SCALE, 125*SCREEN_SCALE+2*num, CGRectGetWidth([UIScreen mainScreen].bounds) - 2*72*SCREEN_SCALE, 1);
    if (2*num >= (NSInteger)(CGRectGetWidth([UIScreen mainScreen].bounds) - 2*72*SCREEN_SCALE)) {
        num = 0;
    }


    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupCamera];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
    [_session stopRunning];
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    _output.rectOfInterest = CGRectMake((180*SCREEN_SCALE)/SCREEN_HEIGHT,((SCREEN_WIDTH-230*SCREEN_SCALE)/2)/SCREEN_WIDTH,230*SCREEN_SCALE/SCREEN_HEIGHT,230*SCREEN_SCALE/SCREEN_WIDTH);
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;

    _preview.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));


    
    [self.view.layer insertSublayer:self.preview atIndex:0];

    
    
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    [self.navigationController popViewControllerAnimated:YES];
    if(self.qrCodeScanSuccess)
    {
        self.qrCodeScanSuccess(stringValue);
    }

}



@end
