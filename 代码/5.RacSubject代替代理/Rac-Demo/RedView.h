//
//  RevView.h
//  Rac-Demo
//
//  Created by Jentle on 2021/6/9.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"

NS_ASSUME_NONNULL_BEGIN

@interface RedView : UIView


@property(strong, nonatomic) RACSubject *clickSubject;

@end

NS_ASSUME_NONNULL_END
