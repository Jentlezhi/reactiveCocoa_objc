//
//  RedView.m
//  Rac-Demo
//
//  Created by Jentle on 2021/6/9.
//

#import "RedView.h"

@implementation RedView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.redColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (RACSubject *)clickSubject {
    
    if (!_clickSubject) {
        _clickSubject = [RACSubject subject];
    }
    return _clickSubject;
}

- (void)tapAction {
    
    [self.clickSubject sendNext:@"RedView传来的数据"];
}



@end
