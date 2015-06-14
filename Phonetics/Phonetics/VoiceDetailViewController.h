//
//  VoiceDetailViewController.h
//  Phonetics
//
//  Created by yc on 15-6-3.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceItem.h"
#import <iAd/iAd.h>

@interface VoiceDetailViewController : UIViewController <ADBannerViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    ADBannerView *bannerView;
}

@property (nonatomic, strong) VoiceItem *item;
@property (nonatomic, weak) IBOutlet UIButton *selectMaleOrFemaleBtn;	
@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UIButton *voiceButton;
@property (nonatomic, weak) IBOutlet UIButton *voiceBkgBtn;
@property (nonatomic, weak) IBOutlet UIImageView *gifImageView;
@property (nonatomic, weak) IBOutlet UITextView *describeTextView;
@property (nonatomic, weak) IBOutlet UIImageView *describeIcon;
@property (nonatomic, weak) IBOutlet UITableView *stepTableView;

@property (nonatomic, weak) IBOutlet UIView *describeView;
@property (nonatomic, weak) IBOutlet UIView *stepView;
@property (nonatomic, weak) IBOutlet UIView *simView;
@property (nonatomic, weak) IBOutlet UIView *liView;
- (IBAction)voiceButtonClick:(id)sender;
- (IBAction)backButtonClick:(id)sender;
- (IBAction)maleOrFemaleBtnClicked:(id)sender;
@end
