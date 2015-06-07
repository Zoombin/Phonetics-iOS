//
//  VoiceItem.h
//  Phonetics
//
//  Created by 颜超 on 15/6/7.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceItem : NSObject

@property (nonatomic, strong) NSString *voiceLong;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *imgName;

- (id)initWithAttribte:(NSDictionary *)dict;
+ (NSArray *)createWithArray:(NSArray *)arr;
@end
