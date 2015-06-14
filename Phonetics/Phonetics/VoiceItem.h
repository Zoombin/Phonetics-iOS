//
//  VoiceItem.h
//  Phonetics
//
//  Created by 颜超 on 15/6/7.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceItem : NSObject

@property (nonatomic, strong) NSString *voiceFemaleLong;
@property (nonatomic, strong) NSString *startFemaleTime;
@property (nonatomic, strong) NSString *endFemaleTime;
@property (nonatomic, strong) NSString *voiceMaleLong;
@property (nonatomic, strong) NSString *startMaleTime;
@property (nonatomic, strong) NSString *endMaleTime;
@property (nonatomic, strong) NSString *picsFront;
@property (nonatomic, strong) NSString *picsSides;
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) NSString *describeText;
@property (nonatomic, strong) NSString *stepDescribes;
@property (nonatomic, strong) NSString *stepTypes;
@property (nonatomic, strong) NSString *stepCount;

- (id)initWithAttribte:(NSDictionary *)dict;
+ (NSArray *)createWithArray:(NSArray *)arr;
@end
