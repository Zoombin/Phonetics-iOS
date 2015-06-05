//
//  ViewController.h
//  Phonetics
//
//  Created by yc on 15-6-3.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIView *menuView;
- (IBAction)menuButtonClicked:(id)sender;
@end

