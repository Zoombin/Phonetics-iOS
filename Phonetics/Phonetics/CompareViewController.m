//
//  CompareViewController.m
//  Phonetics
//
//  Created by yc on 15-6-24.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import "CompareViewController.h"
#import "VoiceSelectViewController.h"

@interface CompareViewController ()

@end

@implementation CompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"音标对比";
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)preBtnClicked:(id)sender {
    
}

- (IBAction)nextBtnClicked:(id)sender {
    
}

- (void)voiceSelected:(VoiceItem *)item andIsUp:(BOOL)isUp {
    NSLog(@"%@", item.name);
    if (isUp) {
        
    } else {
        
    }
}

- (IBAction)selectVoiceUpBtnClicked:(id)sender {
    VoiceSelectViewController *selectViewController = [VoiceSelectViewController new];
    selectViewController.delegate = self;
    selectViewController.isUp = YES;
    selectViewController.basicArray = _basicArray;
    [self.navigationController pushViewController:selectViewController animated:YES];
}

- (IBAction)selectVoiceDownBtnClicked:(id)sender {
    VoiceSelectViewController *selectViewController = [VoiceSelectViewController new];
    selectViewController.delegate = self;
    selectViewController.isUp = NO;
    selectViewController.basicArray = _basicArray;
    [self.navigationController pushViewController:selectViewController animated:YES];
}

- (IBAction)maleOrFemaleBtn1Clicked:(id)sender {
    
}

- (IBAction)maleOrFemaleBtn2Clicked:(id)sender {
    
}

@end
