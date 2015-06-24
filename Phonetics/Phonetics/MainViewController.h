//
//  ViewController.h
//  Phonetics
//
//  Created by yc on 15-6-3.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceCell.h"

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, VoiceCellDelegate>


@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIView *menuView;
@property (nonatomic, weak) IBOutlet UITableView *menuTableView;
- (IBAction)menuButtonClicked:(id)sender;
@end

