//
//  QMAlert.h
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/5/17.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kMainCellColor [UIColor colorWithRed:248/255.0 green:248/255.0 blue:255/255.0 alpha:1]

#define kInputViewHeight 50

#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define kStatusBarAndNavHeight (kStatusBarHeight + 44.0)

#define QM_IS_IPHONEX ((kStatusBarHeight == 44)?YES:NO)

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight (QM_IS_IPHONEX ? ([[UIScreen mainScreen] bounds].size.height - 34) : ([[UIScreen mainScreen] bounds].size.height))
#define kScreenAllHeight  [[UIScreen mainScreen] bounds].size.height

#define kIphone6sScaleWidth [[UIScreen mainScreen] bounds].size.width/375

#define QM_Color(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]


//十进制颜色转换
#define QMRGBA(r,g,b,a)         [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
//十六进制颜色转换（0xFFFFFF）
#define QMHEXRGB(hex)        [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define QMHEXSRGB(hexStr)        [UIColor colorWithRed:strtoul([[hexStr substringWithRange:NSMakeRange(hexStr.length - 6, 2)] UTF8String],0,16)/255.0 green:strtoul([[hexStr substringWithRange:NSMakeRange(hexStr.length - 4, 2)] UTF8String],0,16)/255.0 blue:strtoul([[hexStr substringWithRange:NSMakeRange(hexStr.length - 2, 2)] UTF8String],0,16)/255.0 alpha:1.0]

@interface QMAlert : NSObject

+ (UIWindow *)mainWindow;

+ (void)showMessage:(NSString *)message;

+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize;

+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize Width:(CGFloat)width;

+ (CGFloat)calcLabelHeight: (NSString *)text font: (UIFont *)font;

+ (void)showMessageAtCenter:(NSString *)message;

+ (UIColor *)colorWithHexString: (NSString *)color;

@end
