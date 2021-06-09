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
    
    RACSubject *subject = [RACSubject subject];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"1-%@",x);
    }];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"2-%@",x);
    }];
    //RACSubject 遵守了RACSubscriber协议，所以可以发送消息
    [subject sendNext:@"123"];
    
    self.subject = subject;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.subject sendNext:@"234"];
}


@end
