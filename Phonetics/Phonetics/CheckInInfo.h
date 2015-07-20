//
//  CheckInInfo.h
//  Phonetics
//
//  Created by yc on 15-7-20.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckInInfo : NSObject

@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *lastdate;
@property (nonatomic, strong) NSString *times;

- (id)initWithAttribte:(NSDictionary *)dict;
@end
