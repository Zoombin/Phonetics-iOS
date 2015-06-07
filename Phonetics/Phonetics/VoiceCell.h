//
//  VoiceCell.h
//  Phonetics
//
//  Created by yc on 15-6-3.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceItem.h"

@protocol VoiceCellDelegate <NSObject>
- (void)voiceButtonClicked:(VoiceItem *)item;
@end

@interface VoiceCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *describeLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *voicesScrollView;
@property (nonatomic, weak) id<VoiceCellDelegate> delegate;
- (void)showVoices:(NSArray *)arr;
@end
