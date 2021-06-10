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
@property(strong, nonatomic) UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self liftSelector];
}

//1.替代代理
- (void)signalForSelector {
    
    [[self rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"接收到了屏幕点击的信号");
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.touchTime ++;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTE" object:@{@"object":@"xxx"} userInfo:@{@"userInfo":@"xxx"}];
    
}
//2.代替kvo，更方便的监听
- (void)kvo {
    
    [[self rac_valuesForKeyPath:@"touchTime" observer:nil] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

//3.监听事件
- (void)signalForControlEvents {
    
    [self.view addSubview:self.btn];
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@",x);
    }];
}
//4.代替通知
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
// 5.监听文本框文字的改变
- (void)subscribeTextSignal {
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.textField.placeholder = @"请输入文字";
    self.textField.backgroundColor = UIColor.orangeColor;
    self.textField.center = self.view.center;
    [self.view addSubview:self.textField];
    [self.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
    
}

// 6.处理当界面有多次请求，需要都获取到数据时，才能展示界面
- (void)liftSelector {
    RACSignal *aSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"开始请求数据a");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"数据a请求完毕");
            [subscriber sendNext:@"数据a++++++++++++"];
        });
        return nil;
    }];
    
    RACSignal *bSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"开始请求数据b");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"数据b请求完毕");
            [subscriber sendNext:@"数据b------------"];
        });
        return nil;
    }];
    
    [self rac_liftSelector:@selector(updateUIWithaData:bData:) withSignalsFromArray:@[aSignal,bSignal]];
}

- (void)updateUIWithaData:(NSString *)aData bData:(NSString *)bData {
    
    NSLog(@"数据a和数据b请求完毕，开始更新UI");
    UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    l1.center = self.view.center;
    l1.textColor = UIColor.blackColor;
    l1.text = aData;
    l1.font = [UIFont systemFontOfSize:13.f];
    [self.view addSubview:l1];
    
    UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake(l1.frame.origin.x, CGRectGetMaxY(l1.frame) + 20, 150, 30)];
    l2.textColor = UIColor.blackColor;
    l2.text = bData;
    l2.font = [UIFont systemFontOfSize:13.f];
    [self.view addSubview:l2];
    
}

@end
