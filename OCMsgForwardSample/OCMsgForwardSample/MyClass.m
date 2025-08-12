//
//  MyClass.m
//  OCMsgForwardSample
//
//  Created by Jack on 8/12/25.
//

#import "MyClass.h"
#import <objc/runtime.h>

// 备用接收者类
@interface AlternateObject : NSObject
- (void)anotherMethod;
- (void)unknownMethod;
@end

@implementation AlternateObject

- (void)anotherMethod {
    NSLog(@"备用对象处理 anotherMethod");
}

- (void)unknownMethod {
    NSLog(@"备用对象处理 unknownMethod");
}
@end


NS_ASSUME_NONNULL_BEGIN

@implementation MyClass

// 第一步：动态方法解析
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"%@ entered", NSStringFromSelector(_cmd));
    if (sel == @selector(dynamicMethod)) {
        // 动态添加方法实现
        class_addMethod([self class], sel, (IMP)dynamicIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

// 添加的方法实现
void dynamicIMP(id self, SEL _cmd) {
    NSLog(@"动态添加的方法被调用");
}

// 第二步：备用接收者
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"%@ entered", NSStringFromSelector(_cmd));
    
    if (aSelector == @selector(anotherMethod)) {
        AlternateObject *altObj = [AlternateObject new];
        if ([altObj respondsToSelector:aSelector]) {
            return altObj;  // 转发给其他对象处理
        }
    }
    return [super forwardingTargetForSelector:aSelector];
}

// 第三步：完整消息转发
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"%@ entered", NSStringFromSelector(_cmd));

    
    if (aSelector == @selector(unknownMethod)) {
        // 为不存在的方法生成方法签名
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%@ entered", NSStringFromSelector(_cmd));
    
    if ([AlternateObject instancesRespondToSelector:anInvocation.selector]) {
        AlternateObject *altObj = [AlternateObject new];
        [anInvocation invokeWithTarget:altObj];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

// 最终未处理
- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"%@ entered", NSStringFromSelector(_cmd));
    
    NSLog(@"无法识别选择器: %@", NSStringFromSelector(aSelector));
    [super doesNotRecognizeSelector:aSelector];
}

@end

NS_ASSUME_NONNULL_END
