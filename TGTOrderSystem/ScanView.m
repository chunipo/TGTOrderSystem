//
//  ScanView.m
//  TGTWiFi
//
//  Created by TGT-Tech on 16/11/15.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "ScanView.h"


#define KSCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define XCenter self.center.x
#define SWidth (300)

@interface ScanView() <AVCaptureMetadataOutputObjectsDelegate> {
    
    UIView      *_qrBgView;
    UIImageView *_qrLine;
    NSTimer     *timer;
    int         num;
    BOOL        upOrdown;
}
@property (strong,nonatomic) AVCaptureDevice *device;
@property (strong,nonatomic) AVCaptureDeviceInput *input;
@property (strong,nonatomic) AVCaptureMetadataOutput *output;
@property (strong,nonatomic) AVCaptureSession *session;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *preview;

@end

@implementation ScanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _initView];
        [self creatScanSession];
    }
    return self;
}
- (void)_initView {
    
    _qrBgView = [[UIView alloc] initWithFrame:CGRectMake((KSCREEN_WIDTH-SWidth)/2,(KSCREEN_HEIGHT-SWidth)/2-100,SWidth,SWidth)];
    [self addSubview:_qrBgView];
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i % 2 * (SWidth - 16), i / 2 * (SWidth - 16), 16, 16)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ScanQR%d",i+1]];
        [_qrBgView addSubview:imageView];
    }
    _qrLine = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, SWidth - 40, 1)];
    _qrLine.image = [UIImage imageNamed:@"line.png"];
    [_qrBgView addSubview:_qrLine];
    // 初始
    upOrdown = NO;
    num =0;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _qrBgView.bottom + 20, KScreenWidth, 30)];
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.text = @"请将二维码放置扫描框中";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipLabel];
}
- (void)creatScanSession {
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    _output.rectOfInterest =[self rectOfInterestByScanViewRect:_qrBgView.frame];
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
    }
    // 条码类型
    _output.metadataObjectTypes =@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode];
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResize;
    _preview.frame =self.bounds;
    [self.layer insertSublayer:self.preview atIndex:0];
    [self bringSubviewToFront:_qrBgView];
    [self setOverView];
    // Start
    [self startScanQrCode];
}
- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat x = ((height - CGRectGetHeight(rect)) / 2 -100) / height;
    CGFloat y =  (width - CGRectGetWidth(rect)) / 2 / width;
    
    CGFloat w = CGRectGetHeight(rect) / height;
    CGFloat h = CGRectGetWidth(rect) / width;
    
    return CGRectMake(x, y, w, h);
}
#pragma mark - 添加模糊效果
- (void)setOverView {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat x = CGRectGetMinX(_qrBgView.frame);
    CGFloat y = CGRectGetMinY(_qrBgView.frame);
    CGFloat w = CGRectGetWidth(_qrBgView.frame);
    CGFloat h = CGRectGetHeight(_qrBgView.frame);
    
    [self creatView:CGRectMake(0, 0, width, y)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(0, y + h, width, height - y - h)];
    [self creatView:CGRectMake(x + w, y, width - x - w, h)];
}
- (void)creatView:(CGRect)rect {
    CGFloat alpha = 0.5;
    UIColor *backColor = [UIColor darkGrayColor];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    view.alpha = alpha;
    [self addSubview:view];
}
// 开始扫描
- (void)startScanQrCode {
    [_session startRunning];
    timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(qrLineAnimation) userInfo:nil repeats:YES];
}
// 停止扫描
- (void)stopScanQrCode {
    [_session stopRunning];
    [timer invalidate];
}
// 扫描动画
- (void)qrLineAnimation {
    _qrLine.hidden = NO;
    if (upOrdown == NO) {
        num ++;
        _qrLine.frame = CGRectMake(20, 2*num, SWidth - 40, 2);
        if (2*num >= SWidth-1) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _qrLine.frame = CGRectMake(20, 2*num, SWidth - 40, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count>0) {
        // 停止扫描
        [self stopScanQrCode];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        // 输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(getResponse:)]) {
            [self.delegate getResponse:metadataObject.stringValue];
        }
    }
}
@end
