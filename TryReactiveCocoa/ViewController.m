//
//  ViewController.m
//  TryReactiveCocoa
//
//  Created by Alan.Yen on 2015/9/17.
//  Copyright (c) 2015年 17Life All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textField1;
@property (strong, nonatomic) IBOutlet UITextField *textField2;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) NSString *test1;
@property (strong, nonatomic) NSString *test2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField1.text = @"test1=";
    self.textField2.text = @"test2=";
    [RACObserve(self, test1) subscribeNext:^(NSString *newValue) {
        NSString *message = [NSString stringWithFormat:@"test1 更改了!!\n(%@)", newValue];
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:@"確定"
                          otherButtonTitles:nil] show];
    }];
    
    [[RACObserve(self, test2)
      filter:^(NSString *newValue) {
          return [newValue hasPrefix:@"test2="];
      }]
     subscribeNext:^(NSString *newValue) {
         NSString *message = [NSString stringWithFormat:@"test2 更改了!!\n(%@)", newValue];
         [[[UIAlertView alloc] initWithTitle:@""
                                     message:message
                                    delegate:nil
                           cancelButtonTitle:@"確定"
                           otherButtonTitles:nil] show];
     }];
    
    RAC(self, submitButton.enabled) =
    [RACSignal combineLatest:@[self.textField1.rac_textSignal,
                               self.textField2.rac_textSignal]
                      reduce:^id (NSString *test1, NSString *test2) {
                          return @(test1.length > 6 && test2.length > 6);
                      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateTest1 {
    [self.view endEditing:YES];
    self.test1 = self.textField1.text;
}

- (IBAction)updateTest2 {
    [self.view endEditing:YES];
    self.test2 = self.textField2.text;
}

- (IBAction)submit {
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"submit"
                               delegate:nil
                      cancelButtonTitle:@"確定"
                      otherButtonTitles:nil] show];
}

@end
