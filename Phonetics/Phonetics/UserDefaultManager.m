//
//  UserDefaultManager.m
//  Phonetics
//
//  Created by yc on 15-6-25.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "UserDefaultManager.h"

@implementation UserDefaultManager

+ (NSString *)getUserSaveValues {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *values = [userDefaults objectForKey:COMPARE_VALUES];
    if (values) {
        return values;
    }
    return @"";
}

+ (void)saveValues:(NSString *)str {
    if ([str length] > 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:str forKey:COMPARE_VALUES];
        [userDefaults synchronize];
    }
}
@end