//
//  TutorialFirstStepViewController.h
//  Phonetics
//
//  Created by yc on 15-7-22.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationButton.h"

@interface TutorialFirstStepViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIView *stepView;
@property (nonatomic, weak) IBOutlet AnimationButton *stepButton;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UILabel *step1Label;

- (IBAction)voiceButtonClicked:(id)sender;
- (IBAction)closeButtonClicked:(id)sender;
@end
