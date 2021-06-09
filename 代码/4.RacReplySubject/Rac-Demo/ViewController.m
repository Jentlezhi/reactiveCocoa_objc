//
//  ViewController.m
//  Rac-Demo
//
//  Created by Jentle on 2021/6/8.
//

#import "ViewController.h"
#import "ReactiveObjC.h"

@interface ViewController ()


@property(strong, nonatomic) RACSubject *subject;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"1-%@",x);
    }];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"2-%@",x);
    }];
    
    [subject sendNext:@"123"];
    //RACReplaySubject与RACSubject的区别：RACReplaySubject可以先发送信号再订阅信号；
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"3-%@",x);
    }];
    
    self.subject = subject;
    
    /*
     1-123
     2-123
     3-123
     */
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.subject sendNext:@"234"];
}


@end
