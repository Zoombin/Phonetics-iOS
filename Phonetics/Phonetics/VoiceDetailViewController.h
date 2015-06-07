//
//  VoiceDetailViewController.h
//  Phonetics
//
//  Created by yc on 15-6-3.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceItem.h"

@interface VoiceDetailViewController : UIViewController

@property (nonatomic, strong) VoiceItem *item;
@property (nonatomic, weak) IBOutlet UIButton *voiceButton;
@property (nonatomic, weak) IBOutlet UIButton *voiceBkgBtn;
- (IBAction)voiceButtonClick:(id)sender;
- (IBAction)backButtonClick:(id)sender;
@end
