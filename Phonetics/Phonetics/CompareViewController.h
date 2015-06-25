//
//  CompareViewController.h
//  Phonetics
//
//  Created by yc on 15-6-24.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceSelectViewController.h"

@interface CompareViewController : UIViewController <VoiceSelectDelegate>

@property (nonatomic, weak) IBOutlet UIView *voiceView1;
@property (nonatomic, weak) IBOutlet UIView *voiceView2;
@property (nonatomic, weak) IBOutlet UIButton *voiceButton1;
@property (nonatomic, weak) IBOutlet UIButton *voiceButton2;
@property (nonatomic, weak) IBOutlet UIButton *selectMOrFBtn1;
@property (nonatomic, weak) IBOutlet UIButton *selectMOrFBtn2;
@property (nonatomic, weak) IBOutlet UIImageView *gifImageView1;
@property (nonatomic, weak) IBOutlet UIImageView *gifImageView2;
@property (nonatomic, strong) NSArray *basicArray;

- (IBAction)backBtnClicked:(id)sender;
- (IBAction)preBtnClicked:(id)sender;
- (IBAction)nextBtnClicked:(id)sender;
- (IBAction)selectVoiceUpBtnClicked:(id)sender;
- (IBAction)selectVoiceDownBtnClicked:(id)sender;
- (IBAction)playVoiceButton1:(id)sender;
- (IBAction)playVoiceButton2:(id)sender;

- (IBAction)maleOrFemaleBtn1Clicked:(id)sender;
- (IBAction)maleOrFemaleBtn2Clicked:(id)sender;
@end
