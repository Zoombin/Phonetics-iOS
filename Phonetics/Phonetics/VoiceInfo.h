//
//  VoiceInfo.h
//  Phonetics
//
//  Created by yc on 15-6-3.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceInfo : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *describeInfo;
@property (nonatomic, strong) NSArray *voices;

- (id)initWithAttribte:(NSDictionary *)dict;
+ (NSArray *)createWithArray:(NSArray *)arr;
@end
