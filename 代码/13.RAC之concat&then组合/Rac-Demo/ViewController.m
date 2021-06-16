//
//  ViewController.m
//  Rac-Demo
//
//  Created by Jentle on 2021/6/8.
//

#import "ViewController.h"
#import "ReactiveObjC.h"
#import "RACReturnSignal.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self merge];
}

- (void)concat {
    
    NSLog(@"开始A请求");
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@{@"data":@"数据A",@"index":@"0"}];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    NSLog(@"开始B请求");
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@{@"data":@"数据B",@"index":@"1"}];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    RACSignal *concatSignal = [signalA concat:signalB];
    
    [concatSignal subscribeNext:^(NSDictionary *x) {
        NSInteger index = [[x valueForKey:@"index"] integerValue];
        NSString  *data = [x valueForKey:@"data"];
        NSLog(@"index:%ld,data:%@",(long)index,data);
    }];
    
}

//会忽略第一个信号！！！！！！
- (void)then {
    
    NSLog(@"开始A请求");
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"发送A数据");
            [subscriber sendNext:@{@"data":@"数据A",@"index":@"0"}];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    NSLog(@"开始B请求");
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"发送B数据");
            [subscriber sendNext:@{@"data":@"数据B",@"index":@"1"}];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    RACSignal *thenSignal = [signalA then:^RACSignal * _Nonnull{
        return signalB;
    }];
    
    [thenSignal subscribeNext:^(NSDictionary *x) {
        NSInteger index = [[x valueForKey:@"index"] integerValue];
        NSString  *data = [x valueForKey:@"data"];
        NSLog(@"index:%ld,data:%@",(long)index,data);
    }];
}

- (void)merge {
    
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    RACSubject *subjectC = [RACSubject subject];
    
    RACSignal *mSignal = [[subjectA merge:subjectB] merge:subjectC];
    
    [mSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subjectA sendNext:@"数据A"];
    [subjectA sendNext:@"数据B"];
    [subjectA sendNext:@"数据C"];
}



@end
