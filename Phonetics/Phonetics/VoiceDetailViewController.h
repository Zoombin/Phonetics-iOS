//
//  VoiceDetailViewController.h
//  Phonetics
//
//  Created by yc on 15-6-3.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceItem.h"
#import "GDTMobBannerView.h"

@interface VoiceDetailViewController : UIViewController <GDTMobBannerViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    GDTMobBannerView *bannerView;
    UILabel *checkInLabel;
}

@property (nonatomic, strong) VoiceItem *item;
@property (nonatomic, assign) BOOL isBasic;
@property (nonatomic, strong) NSArray *voiceArray;
@property (nonatomic, weak) IBOutlet UIButton *selectMaleOrFemaleBtn;	
@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UIButton *voiceButton;
@property (nonatomic, weak) IBOutlet UIButton *voiceBkgBtn;
@property (nonatomic, weak) IBOutlet UIImageView *gifImageView;
@property (nonatomic, weak) IBOutlet UITextView *describeTextView;
@property (nonatomic, weak) IBOutlet UITableView *stepTableView;
@property (nonatomic, weak) IBOutlet UITableView *exampleTableView;

@property (nonatomic, weak) IBOutlet UIView *describeView;
@property (nonatomic, weak) IBOutlet UIView *stepView;
@property (nonatomic, weak) IBOutlet UIView *liView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UILabel *voiceLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, weak) IBOutlet UIButton *preButton;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
- (IBAction)nextBtnClicked:(id)sender;
- (IBAction)preBtnClicked:(id)sender;
- (IBAction)voiceButtonClick:(id)sender;
- (IBAction)backButtonClick:(id)sender;
- (IBAction)maleOrFemaleBtnClicked:(id)sender;
@end
