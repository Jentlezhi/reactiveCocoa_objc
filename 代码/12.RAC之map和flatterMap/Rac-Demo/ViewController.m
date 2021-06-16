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
    [self flattenMap2];
}

- (void)map {
    
    RACSubject *subject = [RACSubject subject];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subject-%s-%@",__func__,x);
    }];
    
    RACSignal *bindSignal = [subject map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%@%@",@"+++++",value];
    }];
    
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"bindSignal-%s-%@",__func__,x);
    }];
    
    [subject sendNext:@"123"];
    
}

- (void)flattenMap {
    
    RACSubject *subject = [RACSubject subject];
    
    RACSignal *bindSignal = [subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return [RACReturnSignal return:[NSString stringWithFormat:@"%@%@",@"+++++",value]];
    }];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%s-%@",__func__,x);
    }];
    
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%s-%@",__func__,x);
    }];
    
    [subject sendNext:@"123"];
    
}

//信号中的信号
- (void)flattenMap2 {
    
    RACSubject *subject = [RACSubject subject];
    
    RACSubject *signalOfSignal = [RACSubject subject];
    //方法一
    [signalOfSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"signalOfSignal-%@",x);
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"方法一：x-%@",x);
        }];
    }];
    
    //方法二
    [[signalOfSignal flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
            return value;
        }] subscribeNext:^(id  _Nullable x) {
            NSLog(@"方法二：x-%@",x);
    }];
    
    //方法三
    [signalOfSignal.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"方法三：x-%@",x);
    }];
    
    [signalOfSignal sendNext:subject];
    
    [subject sendNext:@"123"];
    
    
}


@end
