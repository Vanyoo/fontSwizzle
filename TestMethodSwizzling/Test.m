//
//  Test.m
//  TestMethodSwizzling
//
//  Created by van on 2023/11/20.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "TestMethodSwizzling.h"
#import "NSCTFont.h"
#import "objc/runtime.h"

void lm_hookMethod(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
    NSLog(@"\n🎉 print start to change\n");
    if (originalMethod) {
        NSLog(@"originalMethod get it, class:%@,method:%@\n", NSStringFromClass(originalClass), [NSString stringWithUTF8String:sel_getName(method_getName(originalMethod))]);
        //给原方法添加替换方法实现，为了避免原方法没有实现
        BOOL addSucc = class_addMethod(swizzledClass,
                                       originalSelector,
                                       method_getImplementation(swizzledMethod),
                                       method_getTypeEncoding(swizzledMethod));
        //成功，将原方法的实现替换到替换方法的实现
        if (addSucc) {
            NSLog(@"add method success\n");
        }
    }
    if (swizzledMethod) {
        NSLog(@"swizzledMethod get it, class:%@,method:%@\n", NSStringFromClass(swizzledClass), [NSString stringWithUTF8String:sel_getName(method_getName(swizzledMethod))]);
    }
    if(originalMethod && swizzledMethod && originalMethod != swizzledMethod) {
        NSLog(@"\n🎉 confirm to change\n");
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation NSObject (Thunder)
typedef NSTextField* (*InitImpType)(id self, SEL selector);
static InitImpType originalImp;
SEL originalClassMethodSel;
static NSFont *DEFAULT_FONT;

+(void)changeMethod:(char *)name om:(NSString*)om sm:(NSString*)sm {
    Class originalClass = objc_getClass(name);
    originalClassMethodSel = NSSelectorFromString(om);
    DEFAULT_FONT = [NSFont fontWithName:@"JB-Mono-ND-MiS" size:NSFont.systemFontSize];
    Method m1 = class_getInstanceMethod(originalClass, originalClassMethodSel);
    originalImp = (InitImpType)method_getImplementation(m1); // save the IMP of originalMethodName
    lm_hookMethod(objc_getClass(name), originalClassMethodSel, [self class], NSSelectorFromString(sm));
    NSLog(@"Change class %s's %@ to %@ success.", name, om, sm);
}

+ (void)hookThunder{
    [self changeMethod: "NSFont" om:@"fontWithName:size:" sm:@"hook_fontWithName:size:"];
    [self changeMethod: "NSFont" om:@"fontWithName:matrix:" sm:@"hook_fontWithName:matrix:"];
    [self changeMethod: "NSFont" om:@"fontWithDescriptor:size:" sm:@"hook_fontWithDescriptor:size:"];
    [self changeMethod: "NSFont" om:@"systemFontOfSize:" sm:@"hook_systemFontOfSize:"];
    [self changeMethod: "NSFont" om:@"labelFontOfSize:" sm:@"hook_labelFontOfSize:"];
    [self changeMethod: "NSFont" om:@"menuFontOfSize:" sm:@"hook_menuFontOfSize:"];
    [self changeMethod: "NSFont" om:@"menuBarFontOfSize:" sm:@"hook_menuBarFontOfSize:"];
    [self changeMethod: "NSFont" om:@"messageFontOfSize:" sm:@"hook_messageFontOfSize:"];
    [self changeMethod: "NSFont" om:@"paletteFontOfSize:" sm:@"hook_paletteFontOfSize:"];
    [self changeMethod: "NSFont" om:@"toolTipsFontOfSize:" sm:@"hook_toolTipsFontOfSize:"];
    [self changeMethod: "NSFont" om:@"controlContentFontOfSize:" sm:@"hook_controlContentFontOfSize:"];
    [self changeMethod: "NSFont" om:@"systemFontOfSize:weight:" sm:@"hook_systemFontOfSize:weight:"];
    [self changeMethod: "NSFont" om:@"userFontOfSize:" sm:@"hook_userFontOfSize:"];

    [self changeMethod: "NSCTFont" om:@"fontWithSize:" sm:@"hook_fontWithSize:"];
    [self changeMethod: "NSCTFont" om:@"fontForAppearance:" sm:@"hook_fontForAppearance:"];
//    [self changeMethod: "NSCTFont" om:@"screenFont:" sm:@"hook_screenFont:"];
//    [self changeMethod: "NSCTFont" om:@"verticalFont:" sm:@"hook_verticalFont:"];
//    [self changeMethod: "NSCTFont" om:@"fontDescriptor" sm:@"hook_fontDescriptor"]; 返回的应该不是NSFont对象，所以会报错
//    [self changeMethod: "NSCTFont" om:@"fontName" sm:@"hook_fontName"];
//    [self changeMethod: "NSCTFont" om:@"displayName" sm:@"hook_displayName"];
//    [self changeMethod: "NSCTFont" om:@"_similarFontWithName" sm:@"hook__similarFontWithName"];

    [self changeMethod: "NSTextField" om:@"setFont:" sm:@"hook_setFont:"];
    [self changeMethod: "NSTextFieldCell" om:@"setFont:" sm:@"hook_setFont1:"];
    [self changeMethod: "NSButton" om:@"setFont:" sm:@"hook_setFont2:"];
    [self changeMethod: "NSMenuItem" om:@"setFont:" sm:@"hook_setFont3:"];
    [self changeMethod: "NSTabViewItem" om:@"setFont:" sm:@"hook_setFont4:"];
    [self changeMethod: "NSLabel" om:@"setFont:" sm:@"hook_setFont5:"];
}

/* 获取对象的所有方法 */
-(NSArray *)getAllMethods: (Class) c {
    unsigned int methodCount =0;
    Method* methodList = class_copyMethodList(c,&methodCount);
    NSMutableArray *methodsArray = [NSMutableArray arrayWithCapacity:methodCount];
    
    for(int i=0;i<methodCount;i++)
    {
        Method temp = methodList[i];
        const char* name_s =sel_getName(method_getName(temp));
        [methodsArray addObject:[NSString stringWithUTF8String:name_s]];
    }
    free(methodList);
    
    NSLog(@"====> %@ : %@", NSStringFromClass(c), methodsArray.description);
    return methodsArray;
}

- (void)logParents {
    Class c = [self class];
    while(c) {
        NSLog(@"Parent's class : %@\n", NSStringFromClass(c));
        [self getAllMethods: c];
        c = class_getSuperclass(c);
    };
}

//- (CGFloat) getSize:(NSFont*)nf {
//    if ([nf systemFontSize] != NULL) {
//        return [nf systemFontSize];
//    } else {
//        return 12;
//    }
//
//}

// success
- (id)hook_fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSFont hook_FontWithName] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = [NSFont fontWithName:@"JB-Mono-ND-MiS" size:fontSize];
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook_fontWithName:(NSString *)fontName matrix:(const CGFloat *)fontMatrix {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSFont hook_FontWithName_matrix] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = DEFAULT_FONT;
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook_fontWithDescriptor:(NSFontDescriptor *)fontDescriptor size:(CGFloat)fontSize {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSFont hook_FontWithDescriptor] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = [NSFont fontWithName:@"JB-Mono-ND-MiS" size:fontSize];
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook_systemFontOfSize:(CGFloat)fontSize {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSFont hook_systemFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = [NSFont fontWithName:@"JB-Mono-ND-MiS" size:fontSize];
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook_labelFontOfSize:(CGFloat)fontSize {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSFont hook_labelFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = [NSFont fontWithName:@"JB-Mono-ND-MiS" size:fontSize];
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook_menuFontOfSize:(CGFloat)fontSize {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSFont hook_menuFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = [NSFont fontWithName:@"JB-Mono-ND-MiS" size:fontSize];
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook_menuBarFontOfSize:(CGFloat)fontSize {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSFont hook_menuBarFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = [NSFont fontWithName:@"JB-Mono-ND-MiS" size:fontSize];
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook_messageFontOfSize:(CGFloat)fontSize {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSFont hook_messageFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = [NSFont fontWithName:@"JB-Mono-ND-MiS" size:fontSize];
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook_paletteFontOfSize:(CGFloat)fontSize {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSFont hook_paletteFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = [NSFont fontWithName:@"JB-Mono-ND-MiS" size:fontSize];
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook_toolTipsFontOfSize:(CGFloat)fontSize {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSFont hook_toolTipsFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = [NSFont fontWithName:@"JB-Mono-ND-MiS" size:fontSize];
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook_controlContentFontOfSize:(CGFloat)fontSize {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSFont hook_controlContentFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = [NSFont fontWithName:@"JB-Mono-ND-MiS" size:fontSize];
    //NSLog(@"\nFinish~~\n");
    return c;
}
// + (NSFont *)systemFontOfSize:(CGFloat)fontSize weight:(NSFontWeight)weight API_AVAILABLE(macos(10.11));
// success
- (id)hook_systemFontOfSize:(CGFloat)fontSize weight:(NSFontWeight)weight API_AVAILABLE(macos(10.11)) {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSFont hook_systemFontOfSize_withWeight] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = [NSFont fontWithName:@"JB-Mono-ND-MiS" size:fontSize];
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook_userFontOfSize:(CGFloat)fontSize {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSFont hook_userFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = [NSFont fontWithName:@"JB-Mono-ND-MiS" size:fontSize];
    //NSLog(@"\nFinish~~\n");
    return c;
}

// success
- (id)hook_fontWithSize:(CGFloat)size {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSCTFont hook_fontWithSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = [NSFont fontWithName:@"JB-Mono-ND-MiS" size:size];
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook_fontForAppearance:(id)i {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSCTFont hook_fontForAppearance] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = DEFAULT_FONT;
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook_screenFont:(id)i {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSCTFont hook_screenFont] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = DEFAULT_FONT;
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook_verticalFont:(id)i {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSCTFont hook_verticalFont] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = DEFAULT_FONT;
    //NSLog(@"\nFinish~~\n");
    return c;
}
// failed
- (id)hook_fontDescriptor {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSCTFont hook_fontDescriptor] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = DEFAULT_FONT;
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook_displayName {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSCTFont hook_displayName] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = DEFAULT_FONT;
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook_fontName {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSCTFont hook_fontName] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = DEFAULT_FONT;
    //NSLog(@"\nFinish~~\n");
    return c;
}
// success
- (id)hook__similarFontWithName:(id)a {
    Class currentClass = [self class];
    NSLog(@"\n🎉[NSCTFont hook__similarFontWithName] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSFont *c = DEFAULT_FONT;
    //NSLog(@"\nFinish~~\n");
    return c;
}


// success
- (void)hook_setFont:(NSFont*)nf {
    Class currentClass = [self class];
    NSLog(@"\n🎉[hook_setFont] current class:%@\nNSFont class name:%@, font name:%@\n", NSStringFromClass(currentClass), [nf className], [nf fontName]);
    //[self logParents];
//    NSFont *c = [NSFont fontWithName:@"Baskerville" size:NSFont.systemFontSize];
//    NSTextField *c = originalImp(self, originalClassMethodSel);
    [self hook_setFont:DEFAULT_FONT];
    //NSLog(@"\n🎉 Call initialize method success\n");
    //NSLog(@"\nFinish~~\n");
}
// success
- (void)hook_setFont1:(NSFont*)nf {
    Class currentClass = [self class];
    NSLog(@"\n🎉 current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
//    NSFont *c = [NSFont fontWithName:@"Baskerville" size:NSFont.systemFontSize];
//    NSTextField *c = originalImp(self, originalClassMethodSel);
    [self hook_setFont1:DEFAULT_FONT];
    //NSLog(@"\n🎉 Call initialize method success\n");
    //NSLog(@"\nFinish~~\n");
}
// success
- (void)hook_setFont2:(NSFont*)nf {
    Class currentClass = [self class];
    NSLog(@"\n🎉 current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
//    NSFont *c = [NSFont fontWithName:@"Baskerville" size:NSFont.systemFontSize];
//    NSTextField *c = originalImp(self, originalClassMethodSel);
    [self hook_setFont2:DEFAULT_FONT];
    //NSLog(@"\n🎉 Call initialize method success\n");
    //NSLog(@"\nFinish~~\n");
}
// success
- (void)hook_setFont3:(NSFont*)nf {
    Class currentClass = [self class];
    NSLog(@"\n🎉 current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
//    NSFont *c = [NSFont fontWithName:@"Baskerville" size:NSFont.systemFontSize];
//    NSTextField *c = originalImp(self, originalClassMethodSel);
    [self hook_setFont3:DEFAULT_FONT];
    //NSLog(@"\n🎉 Call initialize method success\n");
    //NSLog(@"\nFinish~~\n");
}
// success
- (void)hook_setFont4:(NSFont*)nf {
    Class currentClass = [self class];
    NSLog(@"\n🎉 current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
//    NSFont *c = [NSFont fontWithName:@"Baskerville" size:NSFont.systemFontSize];
//    NSTextField *c = originalImp(self, originalClassMethodSel);
    [self hook_setFont4:DEFAULT_FONT];
    //NSLog(@"\n🎉 Call initialize method success\n");
    //NSLog(@"\nFinish~~\n");
}
// success
- (void)hook_setFont5:(NSFont*)nf {
    Class currentClass = [self class];
    NSLog(@"\n🎉 current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
//    NSFont *c = [NSFont fontWithName:@"Baskerville" size:NSFont.systemFontSize];
//    NSTextField *c = originalImp(self, originalClassMethodSel);
    [self hook_setFont5:DEFAULT_FONT];
    //NSLog(@"\n🎉 Call initialize method success\n");
    //NSLog(@"\nFinish~~\n");
}


@end

static void __attribute__((constructor)) initialize(void) {
    static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [NSObject hookThunder];
        });
}
