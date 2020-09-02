//
//  NSString+LocalizedString.h
//  FBBClientService
//
//  Created by azhen on 2020/9/2.
//

#import <Foundation/Foundation.h>

#undef  NSLocalizedString

NS_ASSUME_NONNULL_BEGIN
@interface NSString (LocalizedString)
+ (NSString *)localizedStringForKey:(NSString *)key
                              value:(NSString *)value
                              table:(NSString *)tableName
                       backupBundle:(NSBundle *)bundle;
@end

NS_ASSUME_NONNULL_END
