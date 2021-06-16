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
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self combineLatest];
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

//任意一个信号请求完成都会订阅到
- (void)merge {
    
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    RACSubject *subjectC = [RACSubject subject];
    
    RACSignal *mSignal = [[subjectA merge:subjectB] merge:subjectC];
    
    [mSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subjectA sendNext:@"数据A"];
    [subjectB sendNext:@"数据B"];
    [subjectC sendNext:@"数据C"];
}

//把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元祖，才会触发压缩流的next事件
- (void)zip {
    
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    
    RACSignal *zSignal = [subjectA zipWith:subjectB];
    
    [zSignal subscribeNext:^(RACTwoTuple *x) {
        NSLog(@"%@",x.first);
        NSLog(@"%@",x.second);
    }];
    
    [subjectA sendNext:@"数据A"];
    [subjectB sendNext:@"数据B"];
}


- (void)combineLatest {
    
    RACSignal *combineSignal = [RACSignal combineLatest:@[self.accountTextField.rac_textSignal,self.pwdTextField.rac_textSignal] reduce:^id (NSString *account, NSString *pwd){
        
        return @(account.length && pwd.length);
    }];
    
    [combineSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    RAC(self.loginBtn,enabled) = combineSignal;
}

- (IBAction)loginClick:(id)sender {
    
    NSLog(@"登录");
}


@end
