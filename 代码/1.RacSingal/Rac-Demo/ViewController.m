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
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"subscriber-send-start");
        //注释掉这个下面的block也不会调用
        [subscriber sendNext:@"123"];
        NSLog(@"subscriber-send-end");
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"disposableWithBlock");
        }];
    }];
    //注释掉这个，上面的block不会被调用
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext-block-%@",x);
    }];/*调用顺序：
        subscriber-send-start
        subscribeNext-block-123
        subscriber-send-end
        disposableWithBlock
        */
    
}


@end
