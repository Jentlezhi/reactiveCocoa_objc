//
//  ViewController.m
//  Rac-Demo
//
//  Created by Jentle on 2021/6/8.
//

#import "ViewController.h"
#import "ReactiveObjC.h"
#import "RedView.h"

@interface ViewController ()


@property(strong, nonatomic) RedView *redView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.redView = [RedView new];
    self.redView.frame = CGRectMake(0, 0, 200, 200);
    self.redView.center = self.view.center;
    [self.view addSubview:self.redView];
    
    //先订阅
    [self.redView.clickSubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}



@end
