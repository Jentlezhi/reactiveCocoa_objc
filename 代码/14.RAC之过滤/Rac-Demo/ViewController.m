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

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self filter];
//    [self ignore];
//    [self take];
//    [self takeUntil];
//    [self distinctUntilChanged];
    [self skip];
}

///过滤信号
- (void)filter {
    
    [[self.accountTextField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
            return value.length > 3;
        }] subscribeNext:^(NSString * _Nullable x) {
            NSLog(@"%@",x);
            self.infoLabel.text = x;
    }];
}

///忽略信号
- (void)ignore {
    
    NSArray *data = @[@"a",@"b",@"c",@"d",@"e",@"a"];
    RACSignal *ignore = [data.rac_sequence.signal ignore:@"a"];
    [ignore subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

///take:取前面几个值；takeLast:取后面几个值，必须要发送完成（）
- (void)take {
    
    RACSubject *subject = [RACSubject subject];
//    [[subject take:1] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    [[subject takeLast:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    //takeLast:必须发送完成
    [subject sendCompleted];
    
}

- (void)takeUntil {
    
    RACSubject *subject = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    //takUntil:只要传入信号发送完成或发送任何数据，就不会再接收源信号的内容
    [[subject takeUntil:signal] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [signal sendCompleted];
    [subject sendNext:@"3"];
    [subject sendNext:@"4"];
}

///如果当前的值跟上一个值相同，就不会订阅到
- (void)distinctUntilChanged {
    
    RACSubject *subject = [RACSubject subject];
    [[subject distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"1"];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"1"];
}

///跳过几个信号
- (void)skip {
    
    RACSubject *subject = [RACSubject subject];
    [[subject skip:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    [subject sendNext:@"4"];
    [subject sendNext:@"5"];
}


@end
