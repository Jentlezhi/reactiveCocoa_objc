//
//  ViewController.m
//  Rac-Demo
//
//  Created by Jentle on 2021/6/8.
//

#import "ViewController.h"
#import "ReactiveObjC.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self multicastConnection];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)multicastConnection {
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"开始发送数据");/*只要订阅者一订阅就会执行该代码，有时候会产生副作用*/
        [subscriber sendNext:@"signal 发出的数据"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者1：%@",x);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者2：%@",x);
    }];
    
    NSLog(@"---------------------------------------------------");
    RACMulticastConnection *connection = [signal publish];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者1：%@",x);
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者2：%@",x);
    }];
    //connect的时候：调用didSubscribe，并回调参数：subscriber = _signal(RACSubject)
    [connection connect];

}


@end
