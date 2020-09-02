//
//  TCMessageManagerFaceView.m
//  QimoQM
//
//  Created by TuChuan on 15/5/13.
//  Copyright (c) 2015年 七陌科技. All rights reserved.
//

#import "TCMessageManagerFaceView.h"
#import "TCExpressionSectionBar.h"

#define FaceSectionBarHeight  46   // 表情下面控件
#define FacePageControlHeight 30  // 表情pagecontrol

#define Pages 2


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
@implementation TCMessageManagerFaceView
{
    UIPageControl *pageControl;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f,5.0f,CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)-(QM_IS_IPHONEX ? 34 : 0)-FacePageControlHeight-FaceSectionBarHeight)];
    scrollView.delegate = self;
    [self addSubview:scrollView];
    [scrollView setPagingEnabled:YES];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.frame)*Pages,CGRectGetHeight(scrollView.frame))];
    
    for (int i= 0;i<Pages;i++) {
        TCFaceView *faceView = [[TCFaceView alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(self.bounds),0.0f,CGRectGetWidth(self.bounds),CGRectGetHeight(scrollView.bounds)) forIndexPath:i];
        [scrollView addSubview:faceView];
        faceView.delegate = self;
    }
    
    pageControl = [[UIPageControl alloc]init];
    [pageControl setFrame:CGRectMake(0,CGRectGetMaxY(scrollView.frame),CGRectGetWidth(self.bounds),FacePageControlHeight)];
    [self addSubview:pageControl];
    [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
    pageControl.numberOfPages = Pages;
    pageControl.currentPage   = 0;
        
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton.frame = CGRectMake(self.bounds.size.width-70, self.bounds.size.height-(QM_IS_IPHONEX ? 34 : 0)-50, 50, 30);
    self.sendButton.backgroundColor = [UIColor colorWithRed:251/255.0 green:206/255.0 blue:0.0 alpha:1];
    self.sendButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.layer.cornerRadius = 15;
    [self.sendButton setTitle:NSLocalizedString(@"button.send", nil) forState:UIControlStateNormal];
    [self addSubview:self.sendButton];
}

#pragma mark  scrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/320;
    pageControl.currentPage = page;
    
}

#pragma mark ZBFaceView Delegate
- (void)didSelecteFace:(NSString *)faceName andIsSelecteDelete:(BOOL)del{
    if ([self.delegate respondsToSelector:@selector(SendTheFaceStr:isDelete:) ]) {
        [self.delegate SendTheFaceStr:faceName isDelete:del];
    }
}


@end
