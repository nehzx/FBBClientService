//
//  PrefixHeader.h
//  Pods
//
//  Created by azhen on 2020/9/2.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h
#import "NSString+LocalizedString.h"

#define Bundle [NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"FBBClientService" withExtension:@"bundle"]]
#define NSLocalizedString(key, comment) \
[NSString localizedStringForKey:key value:@"" table:@"FBBLocalizable" backupBundle:Bundle]

#endif /* PrefixHeader_h */
