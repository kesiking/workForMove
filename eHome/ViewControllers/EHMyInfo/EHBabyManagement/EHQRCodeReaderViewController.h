//
//  EHQRCodeReaderViewController.h
//  eHome
//
//  Created by louzhenhua on 15/7/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^QRCodeScanSuccess)(NSString* qrcode);

@interface EHQRCodeReaderViewController : UIViewController
@property(nonatomic, copy)QRCodeScanSuccess qrCodeScanSuccess;
@end
