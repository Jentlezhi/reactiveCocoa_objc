//
//  ViewController.m
//  Rac-Demo
//
//  Created by Jentle on 2021/6/8.
//

#import "ViewController.h"
#import "ReactiveObjC.h"

@interface ViewController ()

/// signal
@property(strong, nonatomic) RACSignal *signal;
// 强引用，阻止subscriber销毁，那么就不会结束订阅；
@property(strong, nonatomic) id<RACSubscriber> subscriber;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        _subscriber = subscriber;
        [subscriber sendNext:@"123"];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"disposableWithBlock");
        }];
    }];
    RACDisposable *disposabel = [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext-block-%@",x);
    }];
    
    self.signal = signal;
    //手动取消订阅：touchesBegan:中发送数据就不能被订阅
    [disposabel dispose];
    //
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_subscriber sendNext:@"234"];
}


@end
