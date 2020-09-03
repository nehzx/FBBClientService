//
//  FBBManager.m
//  FBBClientService
//
//  Created by azhen on 2020/9/3.
//

#import "FBBManager.h"
#import "QMChatRoomViewController.h"
#import <QMLineSDK/QMLineSDK.h>
#import "QMChatRoomGuestBookViewController.h"
#import "QMAlert.h"
#import "QMManager.h"
@interface FBBManager()

@property (nonatomic, copy) NSString * appKey;
@property (nonatomic, assign) BOOL isPushed;
@property (nonatomic, copy) NSDictionary * dictionary;
@property (nonatomic, assign) BOOL isConnecting;
@property (nonatomic, copy) completion com;

@end

@implementation FBBManager

+ (void)pushChatRoomWithAppKey:(NSString *)appKey
                        userId:(NSString *)userId
                      userName:(NSString *)userName
                    completion:(completion __nullable)completion {
    [self standardManager].appKey = appKey;
    [self standardManager].isPushed = NO;
    [self standardManager].isConnecting = YES;
    [self standardManager].com = completion;
    [QMConnect registerSDKWithAppKey:appKey userName:userName userId:userId];
}

+ (FBBManager *)standardManager {
    static dispatch_once_t onceToken;
    static FBBManager * manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[FBBManager alloc] init];
        [[NSNotificationCenter defaultCenter]addObserver:manager selector:@selector(registerSuccess:) name:CUSTOM_LOGIN_SUCCEED object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:manager selector:@selector(registerFailure:) name:CUSTOM_LOGIN_ERROR_USER object:nil];
    });
    return  manager;
}

/// 注册成功
/// @param sender sender
- (void)registerSuccess:(NSNotification *)sender {
    if ([QMManager defaultManager].selectedPush) {
        [self showChatRoomViewController:self.appKey processType:@"" entranceId:@""]; //
    }else{
        
        // 页面跳转控制
        if (self.isPushed) {
            return;
        }
        
        [QMConnect sdkGetWebchatScheduleConfig:^(NSDictionary * _Nonnull scheduleDic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dictionary = scheduleDic;
                if ([self.dictionary[@"scheduleEnable"] intValue] == 1) {
                    NSLog(@"日程管理");
                    [self starSchedule];
                }else{
                    NSLog(@"技能组");
                    [self getPeers];
                }
            });
        } failBlock:^{
            [self getPeers];
        }];
        
    }
    
    [QMManager defaultManager].selectedPush = NO;
}

/// 注册失败
/// @param sender sender description
- (void)registerFailure:(NSNotification *)sender {
    QMLineError *err = sender.object;
    if (err.errorDesc.length > 0) {
        [QMAlert showMessageAtCenter:err.errorDesc];
    }
    self.isConnecting = NO;
    if (self.com != nil) {
        self.com(nil, [[NSError alloc]initWithDomain:NSOSStatusErrorDomain code:3000 userInfo:@{NSUnderlyingErrorKey: @"客服初始化失败"}]);
    }
}

#pragma mark - 技能组选择
- (void)getPeers {
    [QMConnect sdkGetPeers:^(NSArray * _Nonnull peerArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *peers = peerArray;
            self.isConnecting = NO;
            if (peers.count == 1 && peers.count != 0) {
                [self showChatRoomViewController:[peers.firstObject objectForKey:@"id"] processType:@"" entranceId:@""];
            }else {
                [self showPeersWithAlert:peers messageStr:NSLocalizedString(@"title.type", nil)];
            }
        });
    } failureBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isConnecting = NO;
        });
    }];
}

#pragma mark - 日程管理
- (void)starSchedule {
    self.isConnecting = NO;
    if ([self.dictionary[@"scheduleId"]  isEqual: @""] || [self.dictionary[@"processId"]  isEqual: @""] || [self.dictionary objectForKey:@"entranceNode"] == nil || [self.dictionary objectForKey:@"leavemsgNodes"] == nil) {
        [QMAlert showMessage:NSLocalizedString(@"title.sorryconfigurationiswrong", nil)];
    }else{
        NSDictionary *entranceNode = self.dictionary[@"entranceNode"];
        NSArray *entrances = entranceNode[@"entrances"];
        if (entrances.count == 1 && entrances.count != 0) {
            [self showChatRoomViewController:[entrances.firstObject objectForKey:@"processTo"] processType:[entrances.firstObject objectForKey:@"processType"] entranceId:[entrances.firstObject objectForKey:@"_id"]];
        }else{
            [self showPeersWithAlert:entrances messageStr:NSLocalizedString(@"title.schedule_type", nil)];
        }
    }
}

- (void)showPeersWithAlert: (NSArray *)peers messageStr: (NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"title.type", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button.cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.isConnecting = NO;
    }];
    [alertController addAction:cancelAction];
    for (NSDictionary *index in peers) {
        UIAlertAction *surelAction = [UIAlertAction actionWithTitle:[index objectForKey:@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([self.dictionary[@"scheduleEnable"] integerValue] == 1) {
                [self showChatRoomViewController:[index objectForKey:@"processTo"] processType:[index objectForKey:@"processType"] entranceId:[index objectForKey:@"_id"]];
            }else{
                [self showChatRoomViewController:[index objectForKey:@"id"] processType:@"" entranceId:@""];
            }
        }];
        [alertController addAction:surelAction];
    }
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 跳转聊天界面
- (void)showChatRoomViewController:(NSString *)peerId processType:(NSString *)processType entranceId:(NSString *)entranceId {
    QMChatRoomViewController *chatRoomViewController = [[QMChatRoomViewController alloc] init];
    chatRoomViewController.peerId = peerId;
    chatRoomViewController.isPush = NO;
    chatRoomViewController.avaterStr = @"";
    if ([self.dictionary[@"scheduleEnable"] intValue] == 1) {
        chatRoomViewController.isOpenSchedule = true;
        chatRoomViewController.scheduleId = self.dictionary[@"scheduleId"];
        chatRoomViewController.processId = self.dictionary[@"processId"];
        chatRoomViewController.currentNodeId = peerId;
        chatRoomViewController.processType = processType;
        chatRoomViewController.entranceId = entranceId;
    }else{
        chatRoomViewController.isOpenSchedule = false;
    }
    // 是否接收 chat 自己处理
    if (self.com != nil) {
        self.com(chatRoomViewController, nil);
        return;
    }
    
    UIViewController *rootVC = UIApplication.sharedApplication.windows.firstObject.rootViewController;
    UINavigationController *nav = nil;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController * tabbarVC = (UITabBarController *) rootVC;
        if ([tabbarVC.selectedViewController isKindOfClass:[UINavigationController class]]) {
            nav = tabbarVC.selectedViewController;
            
            [nav pushViewController:chatRoomViewController animated:YES];
            return;
        }
    }
    if ([rootVC isKindOfClass: [UINavigationController class]]) {
        nav = (UINavigationController *)rootVC;
        [nav pushViewController:chatRoomViewController animated:YES];
        return;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:[FBBManager standardManager]];
}


@end
