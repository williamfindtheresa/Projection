//
//  UIViewController+Runtime.m
//  Projection
//
//  Created by 刘昊 on 16/6/22.
//  Copyright © 2016年 刘昊. All rights reserved.
//

#import "UIViewController+Runtime.h"
#import <objc/runtime.h>

@implementation UIViewController (Runtime)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL orignalSEL = @selector(viewWillAppear:);
        SEL swizzingSEL = @selector(swizzing_viewWillAppear:);
        
        Method orignalMethod = class_getInstanceMethod(class, orignalSEL);
        Method swizzingMethod = class_getInstanceMethod(class, swizzingSEL);
        
        BOOL didAddSwizzing = class_addMethod(class,
                                              orignalSEL,
                                              method_getImplementation(swizzingMethod),
                                              method_getTypeEncoding(swizzingMethod));
        if (didAddSwizzing) {
            class_replaceMethod(class,
                                swizzingSEL,
                                method_getImplementation(orignalMethod),
                                method_getTypeEncoding(orignalMethod));
        }else {
            method_exchangeImplementations(orignalMethod, swizzingMethod);
        }
    });
}

- (void)swizzing_viewWillAppear:(BOOL)animated {
    [self swizzing_viewWillAppear:animated];
    NSLog(@"swizzing");
}

@end
