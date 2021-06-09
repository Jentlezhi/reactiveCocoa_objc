//
//  ViewController.m
//  Rac-Demo
//
//  Created by Jentle on 2021/6/8.
//

#import "ViewController.h"
#import "ReactiveObjC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self testEmutor:5];
    [self sequeue];
    
}

- (void)truple {
    //就是
    RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[@"a",@"b",@"c"]];
    NSLog(@"first= %@",tuple.first);
}

- (void)sequeue {
    
    NSArray *array = @[@"a",@"b",@"c",@"d"];
    RACSequence *sequeue = array.rac_sequence;
    NSLog(@"head:%@",sequeue.head);
//    NSLog(@"tail:%@",sequeue.tail);
    sequeue = sequeue.tail;
    /*
     - (RACSequence *)tail {
         RACSequence *sequence = [self.class sequenceWithArray:self.backingArray offset:self.offset + 1];
         sequence.name = self.name;
         return sequence;
     }
     */
    NSLog(@"head:%@",sequeue.head);
//    NSLog(@"tail.tail:%@",sequeue.tail);
    [sequeue.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

/*
 - (RACSignal *)signalWithScheduler:(RACScheduler *)scheduler {
     return [[RACSignal createSignal:^(id<RACSubscriber> subscriber) {
         __block RACSequence *sequence = self;

         return [scheduler scheduleRecursiveBlock:^(void (^reschedule)(void)) {
             if (sequence.head == nil) {
                 [subscriber sendCompleted];
                 return;
             }

             [subscriber sendNext:sequence.head];

             sequence = sequence.tail;
             reschedule();
         }];
     }] setNameWithFormat:@"[%@] -signalWithScheduler: %@", self.name, scheduler];
 }
 */
- (void)testEmutor:(int)time {
    
    [self emuter:^(void (^inBlock)(void)) {
        static int i = 0;
        NSLog(@"%d",i);
        i++;
        if (i < time) {
            inBlock();
        }
        
    }];
}
- (void)emuter:(void(^)(void(^inBlock)(void)))block {
    
    block(^(){
        [self emuter:block];
    });
}

@end
