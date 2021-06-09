//
//  ViewController.m
//  Rac-Demo
//
//  Created by Jentle on 2021/6/8.
//

#import "ViewController.h"
#import "ReactiveObjC.h"

@interface ViewController ()

@property(assign, nonatomic) NSInteger touchTime;
@property(strong, nonatomic) UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
}

//替代代理
- (void)signalForSelector {
    
    [[self rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"接收到了屏幕点击的信号");
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.touchTime ++;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTE" object:@{@"object":@"xxx"} userInfo:@{@"userInfo":@"xxx"}];
    
}

- (void)kvo {
    
    [[self rac_valuesForKeyPath:@"touchTime" observer:nil] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

//监听事件
- (void)signalForControlEvents {
    
    [self.view addSubview:self.btn];
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)addObserver {
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NOTE" object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (UIButton *)btn {
    
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(0, 0, 100, 30);
        _btn.center = self.view.center;
        [_btn setTitle:@"我是按钮" forState:UIControlStateNormal];
        _btn.backgroundColor = UIColor.orangeColor;
        [_btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        
    }
    return _btn;
}

@end
