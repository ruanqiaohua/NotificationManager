//
//  ViewController.m
//  NotificationManager
//
//  Created by 阮巧华 on 2017/5/11.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import "ViewController.h"
#import "NotificationManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NotificationManager manager] userInfoHandler:^(NSDictionary *userInfo) {
        _textView.text = [NSString stringWithFormat:@"%@",userInfo];
    }];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
