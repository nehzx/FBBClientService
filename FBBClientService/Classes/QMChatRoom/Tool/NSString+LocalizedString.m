//
//  NSString+LocalizedString.m
//  FBBClientService
//
//  Created by azhen on 2020/9/2.
//

#import "NSString+LocalizedString.h"

@implementation NSString (LocalizedString)
NSString * const kLocalizedStringNotFound = @"kLocalizedStringNotFound";

+ (NSString *)localizedStringForKey:(NSString *)key
                              value:(NSString *)value
                              table:(NSString *)tableName
                       backupBundle:(NSBundle *)bundle
{
    // First try main bundle
    NSString * string = [[NSBundle mainBundle] localizedStringForKey:key
                                                               value:kLocalizedStringNotFound
                                                               table:tableName];
    if (bundle == nil) {
        bundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"FBBClientService" withExtension:@"bundle"]];
    }
    // Then try the backup bundle
    if ([string isEqualToString:kLocalizedStringNotFound])
    {
        string = [bundle localizedStringForKey:key
                                         value:kLocalizedStringNotFound
                                         table:tableName];
    }

    // Still not found?
    if ([string isEqualToString:kLocalizedStringNotFound])
    {
        NSLog(@"No localized string for '%@' in '%@'", key, tableName);
        string = value.length > 0 ? value : key;
    }
    
    return string;
}
@end
