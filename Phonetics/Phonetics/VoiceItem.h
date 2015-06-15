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
@property (nonatomic, strong) NSString *examples;
@property (nonatomic, strong) NSString *examplesSlowRead;
@property (nonatomic, strong) NSString *examplesRead;
@property (nonatomic, strong) NSString *examplesYB;
@property (nonatomic, strong) NSString *examplesCount;
@property (nonatomic, strong) NSString *similar;
@property (nonatomic, strong) NSString *similarRead;
@property (nonatomic, strong) NSString *similarSlowRead;
@property (nonatomic, strong) NSString *similarYB;
@property (nonatomic, strong) NSString *similarCount;
@property (nonatomic, strong) NSString *similarYBName;
@property (nonatomic, strong) NSString *examplesYBName;
@property (nonatomic, strong) NSString *name;

- (id)initWithAttribte:(NSDictionary *)dict;
+ (NSArray *)createWithArray:(NSArray *)arr;
@end
