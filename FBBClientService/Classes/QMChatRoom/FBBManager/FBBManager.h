//
//  FBBManager.h
//  FBBClientService
//
//  Created by azhen on 2020/9/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^completion)( UIViewController * __nullable chatVC, NSError * _Nullable error);

@interface FBBManager : NSObject
/// 跳转到聊天页面
/// @param appKey 应用ID
/// @param userId 用户ID
/// @param userName 用户昵称
/// @param completion 返回要跳转的控制器
+ (void)pushChatRoomWithAppKey:(NSString *)appKey
                        userId:(NSString *)userId
                      userName:(NSString *)userName
                    completion:(completion __nullable)completion;

@end

NS_ASSUME_NONNULL_END
