//
//  WebViewController.h
//  Phonetics
//
//  Created by 颜超 on 15/8/10.
//  Copyright (c) 2015年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) NSString *url;
@end
