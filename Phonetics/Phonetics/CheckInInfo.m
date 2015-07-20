//
//  CheckInInfo.m
//  Phonetics
//
//  Created by yc on 15-7-20.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "CheckInInfo.h"

@implementation CheckInInfo

- (id)initWithAttribte:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.times = dict[@"times"];
        self.month = dict[@"month"];
        self.lastdate = dict[@"lastdate"];
    }
    return self;
}

@end
