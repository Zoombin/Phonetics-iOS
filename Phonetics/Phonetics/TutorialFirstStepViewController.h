//
//  TutorialFirstStepViewController.h
//  Phonetics
//
//  Created by yc on 15-7-22.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialFirstStepViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIView *stepView;
- (IBAction)voiceButtonClicked:(id)sender;
- (IBAction)closeButtonClicked:(id)sender;
@end
