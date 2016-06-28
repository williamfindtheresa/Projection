//
//  UIControl+Runtime.m
//  Projection
//
//  Created by 刘昊 on 16/6/22.
//  Copyright © 2016年 刘昊. All rights reserved.
//

#import "UIControl+Runtime.h"
#import <objc/runtime.h>

@implementation UIControl (Runtime)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL oringalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzingSelector = @selector(swizzing_sendAction:to:forEvent:);
        
        Method oriMethod = class_getInstanceMethod(class, oringalSelector);
        Method swizzingMethod = class_getInstanceMethod(class, swizzingSelector);
        
        BOOL isAddSwizzing = class_addMethod(class,
                                             oringalSelector,
                                             method_getImplementation(swizzingMethod),
                                             method_getTypeEncoding(swizzingMethod));
        if (isAddSwizzing) {
            class_replaceMethod(class,
                                swizzingSelector,
                                method_getImplementation(oriMethod),
                                method_getTypeEncoding(oriMethod));
        }else{
            method_exchangeImplementations(oriMethod, swizzingMethod);
        }
    });
}

- (void)swizzing_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [self swizzing_sendAction:action to:target forEvent:event];
    NSLog(@"swizzing for UIControl");
}

@end
