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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self RACObserve];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.touchTime++;
}

- (void)RAC {
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    textField.placeholder = @"请输入文字";
    textField.backgroundColor = UIColor.orangeColor;
    textField.center = self.view.center;
    [self.view addSubview:textField];
    
    UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(textField.frame.origin.x, CGRectGetMaxY(textField.frame) + 20, 200, 30)];
    l1.textColor = UIColor.blackColor;
    l1.font = [UIFont systemFontOfSize:13.f];
    [self.view addSubview:l1];
    
//    [textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"%@",x);
//        l1.text = x;
//    }];
    //RAC:用来给某个对象的某个属性绑定信号，只要产生信号内容，就会把内容给属性赋值
    RAC(l1,text) = textField.rac_textSignal;
    
}

- (void)RACObserve {
    
    [RACObserve(self, touchTime) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%d",[x intValue]);
    }];
}

@end
