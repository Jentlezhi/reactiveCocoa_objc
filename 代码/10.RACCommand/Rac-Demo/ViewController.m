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
    
    [self commandExecutionSignals];
}

- (void)commandExecute {
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"input:%@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:[NSString stringWithFormat:@"%@%@",input,@"+234"]];
            return nil;
        }];
    }];
    
    [[command execute:@"123"] subscribeNext:^(id  _Nullable x) {\
        NSLog(@"订阅：%@",x);
    }];
}

- (void)commandExecutionSignals {
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"input:%@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:[NSString stringWithFormat:@"%@%@",input,@"+234"]];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            NSLog(@"命令正在执行");
        }else{
            NSLog(@"命令没有执行/执行完成");
        }
    }];
    
    [command.executionSignals subscribeNext:^(RACSignal *x) {
        NSLog(@"%s-%@",__func__,x);
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"%s-%@",__func__,x);
        }];
    }];
    [command execute:@"123"];
}

//获取信号中发出的最新信号
- (void)commandSwitchToLatest {
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"input:%@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:[NSString stringWithFormat:@"%@%@",input,@"+234"]];
            return nil;
        }];
    }];
    
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%s-%@",__func__,x);
    }];
//    [command.executionSignals subscribeNext:^(RACSignal *x) {
//        NSLog(@"%s-%@",__func__,x);
//        [x subscribeNext:^(id  _Nullable x) {
//            NSLog(@"%s-%@",__func__,x);
//        }];
//    }];
    [command execute:@"123"];
}

//获取信号中发出的最新信号
- (void)switchToLatest {
    
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"a"];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"b"];
        return nil;
    }];
    
    
    
    RACSubject *subject = [RACSubject subject];
    
    
    [subject.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:signalB];
    
}


@end
