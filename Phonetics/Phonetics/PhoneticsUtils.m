//
//  PhoneticsUtils.m
//  Phonetics
//
//  Created by yc on 15-7-20.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "PhoneticsUtils.h"

@implementation PhoneticsUtils

+ (NSString *)getVersion {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

+ (BOOL)isIpad {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSLog(@"ipad");
        return true;
    } else {
        NSLog(@"iphone");
        return false;
    }
}

@end
