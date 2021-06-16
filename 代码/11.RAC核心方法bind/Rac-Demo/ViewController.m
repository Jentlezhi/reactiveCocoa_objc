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
    [self bind];
}

- (void)bind {
    
    RACSubject *subject = [RACSubject subject];
    
    RACSignal *bindSignal = [subject bind:^RACSignalBindBlock{
        
        return ^RACSignal* (id value, BOOL *stop){
            //处理原数据
            return [RACReturnSignal return:[NSString stringWithFormat:@"%@+%@",value,@"****"]];
        };
    }];
    
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"123"];
}


@end
