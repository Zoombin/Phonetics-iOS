//
//  TutorialSecondStepViewController.h
//  Phonetics
//
//  Created by yc on 15-7-22.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceItem.h"
#import "AnimationButton.h"

@interface TutorialSecondStepViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
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

//新手教程
@property (nonatomic, weak) IBOutlet UIView *stepView2;
@property (nonatomic, weak) IBOutlet UIView *stepView3;
@property (nonatomic, weak) IBOutlet UIView *stepView4;
@property (nonatomic, weak) IBOutlet UIView *stepView5;
@property (nonatomic, weak) IBOutlet UIView *stepView6;
@property (nonatomic, weak) IBOutlet UIView *stepView7;
@property (nonatomic, weak) IBOutlet UIView *stepView8;
@property (nonatomic, weak) IBOutlet UIView *stepView9;
@property (nonatomic, weak) IBOutlet UIView *stepView10;
@property (nonatomic, weak) IBOutlet UIView *stepView11;
@property (nonatomic, weak) IBOutlet AnimationButton *clickButton4;
@property (nonatomic, weak) IBOutlet AnimationButton *clickButton5;
@property (nonatomic, weak) IBOutlet AnimationButton *clickButton6;
@property (nonatomic, weak) IBOutlet AnimationButton *clickButton7;
@property (nonatomic, weak) IBOutlet AnimationButton *clickButton8;
@property (nonatomic, weak) IBOutlet AnimationButton *clickButton9;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl6;

@property (nonatomic, weak) IBOutlet UILabel *step2Label;
@property (nonatomic, weak) IBOutlet UIButton *next2Button;
@property (nonatomic, weak) IBOutlet UIButton *close2Button;

@property (nonatomic, weak) IBOutlet UILabel *step3Label;
@property (nonatomic, weak) IBOutlet UIButton *next3Button;
@property (nonatomic, weak) IBOutlet UIButton *close3Button;

@property (nonatomic, weak) IBOutlet UILabel *step4Label;
@property (nonatomic, weak) IBOutlet UIButton *close4Button;

@property (nonatomic, weak) IBOutlet UILabel *step5Label;
@property (nonatomic, weak) IBOutlet UIButton *close5Button;

@property (nonatomic, weak) IBOutlet UILabel *step6Label;
@property (nonatomic, weak) IBOutlet UIButton *close6Button;

@property (nonatomic, weak) IBOutlet UILabel *step7Label;
@property (nonatomic, weak) IBOutlet UIButton *close7Button;

@property (nonatomic, weak) IBOutlet UILabel *step8Label;
@property (nonatomic, weak) IBOutlet UIButton *close8Button;

@property (nonatomic, weak) IBOutlet UILabel *step9Label;
@property (nonatomic, weak) IBOutlet UIButton *close9Button;

@property (nonatomic, weak) IBOutlet UILabel *step10Label;
@property (nonatomic, weak) IBOutlet UIButton *next10Button;
@property (nonatomic, weak) IBOutlet UIButton *close10Button;

@property (nonatomic, weak) IBOutlet UILabel *step11Label;
@property (nonatomic, weak) IBOutlet UIButton *close11Button;

- (IBAction)clickButtonClicked:(id)sender;
- (IBAction)nextStepButtonClicked:(id)sender;
- (IBAction)closeButtonClicked:(id)sender;

@end
