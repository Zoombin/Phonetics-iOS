//
//  VoiceSelectViewController.h
//  Phonetics
//
//  Created by yc on 15-6-24.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceInfo.h"
#import "VoiceItem.h"

@protocol VoiceSelectDelegate <NSObject>
- (void)voiceSelected:(VoiceItem *)item andIsUp:(BOOL)isUp;
@end

@interface VoiceSelectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<VoiceSelectDelegate> delegate;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *basicArray;
@property (nonatomic, assign) BOOL isUp;
@end
