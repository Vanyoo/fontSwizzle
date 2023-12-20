//
//  Test.m
//  TestMethodSwizzling
//
//  Created by van on 2023/11/20.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import "TestMethodSwizzling.h"
#import "NSCTFont.h"
#import "objc/runtime.h"
#import "MMTextMessageCellView.h"
#import "MMTimeStampCellView.h"

#ifdef DEBUG
    #define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define NSLog(...)
#endif

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
NSString *AppleColorEmoji = @"AppleColorEmoji";
NSTableView *table;

+(void)changeMethod:(char *)name om:(NSString*)om sm:(NSString*)sm {
    Class originalClass = objc_getClass(name);
    originalClassMethodSel = NSSelectorFromString(om);
    Method m1 = class_getInstanceMethod(originalClass, originalClassMethodSel);
    originalImp = (InitImpType)method_getImplementation(m1); // save the IMP of originalMethodName
    lm_hookMethod(objc_getClass(name), originalClassMethodSel, [self class], NSSelectorFromString(sm));
    NSLog(@"Change class %s's %@ to %@ success.", name, om, sm);
}

+ (void)hookThunder{
//    [self changeMethod: "NSFont" om:@"fontWithName:size:" sm:@"hook_fontWithName:size:"];
//    [self changeMethod: "NSFont" om:@"fontWithName:matrix:" sm:@"hook_fontWithName:matrix:"];
//    [self changeMethod: "NSFont" om:@"fontWithDescriptor:size:" sm:@"hook_fontWithDescriptor:size:"];
//    [self changeMethod: "NSFont" om:@"systemFontOfSize:" sm:@"hook_systemFontOfSize:"];
//    [self changeMethod: "NSFont" om:@"labelFontOfSize:" sm:@"hook_labelFontOfSize:"];
//    [self changeMethod: "NSFont" om:@"menuFontOfSize:" sm:@"hook_menuFontOfSize:"];
//    [self changeMethod: "NSFont" om:@"menuBarFontOfSize:" sm:@"hook_menuBarFontOfSize:"];
//    [self changeMethod: "NSFont" om:@"messageFontOfSize:" sm:@"hook_messageFontOfSize:"];
//    [self changeMethod: "NSFont" om:@"paletteFontOfSize:" sm:@"hook_paletteFontOfSize:"];
//    [self changeMethod: "NSFont" om:@"toolTipsFontOfSize:" sm:@"hook_toolTipsFontOfSize:"];
//    [self changeMethod: "NSFont" om:@"controlContentFontOfSize:" sm:@"hook_controlContentFontOfSize:"];
//    [self changeMethod: "NSFont" om:@"systemFontOfSize:weight:" sm:@"hook_systemFontOfSize:weight:"];
//    [self changeMethod: "NSFont" om:@"userFontOfSize:" sm:@"hook_userFontOfSize:"];

//    [self changeMethod: "NSCTFont" om:@"fontWithSize:" sm:@"hook_fontWithSize:"];
    [self changeMethod: "NSCTFont" om:@"fontForAppearance:" sm:@"hook_fontForAppearance:"];
//    [self changeMethod: "NSCTFont" om:@"screenFont:" sm:@"hook_screenFont:"];
//    [self changeMethod: "NSCTFont" om:@"verticalFont:" sm:@"hook_verticalFont:"];
//    [self changeMethod: "NSCTFont" om:@"fontDescriptor" sm:@"hook_fontDescriptor"]; 返回的应该不是NSFont对象，所以会报错
//    [self changeMethod: "NSCTFont" om:@"fontName" sm:@"hook_fontName"];
//    [self changeMethod: "NSCTFont" om:@"displayName" sm:@"hook_displayName"];
//    [self changeMethod: "NSCTFont" om:@"_similarFontWithName" sm:@"hook__similarFontWithName"];

//    [self changeMethod: "NSTextField" om:@"setFont:" sm:@"hook_NSTextField_setFont:"];
//    [self changeMethod: "NSTextFieldCell" om:@"setFont:" sm:@"hook_NSTextFieldCell_setFont:"];
//    [self changeMethod: "NSButton" om:@"setFont:" sm:@"hook_NSButton_setFont:"];
//    [self changeMethod: "NSMenuItem" om:@"setFont:" sm:@"hook_NSMenuItem_setFont:"];
//    [self changeMethod: "NSTabViewItem" om:@"setFont:" sm:@"hook_NSTabViewItem_setFont:"];
//    [self changeMethod: "NSLabel" om:@"setFont:" sm:@"hook_NSLabel_setFont:"];
//
//    [self changeMethod: "MMAvatarImageView" om:@"setFont:" sm:@"hook_MMAvatarImageView_setFont:"];
//    [self changeMethod: "MMButton" om:@"setFont:" sm:@"hook_MMButton_setFont:"];
//    [self changeMethod: "MMMessageUnreadTipsButton" om:@"setFont:" sm:@"hook_MMMessageUnreadTipsButton_setFont:"];
//    [self changeMethod: "MMOutlineButton" om:@"setFont:" sm:@"hook_MMOutlineButton_setFont:"];
//    [self changeMethod: "MMTextField" om:@"setFont:" sm:@"hook_MMTextField_setFont:"];
//    [self changeMethod: "NSButton" om:@"setFont:" sm:@"hook_NSButton_setFont:"];
//    [self changeMethod: "NSButtonCell" om:@"setFont:" sm:@"hook_NSButtonCell_setFont:"];
//    [self changeMethod: "NSImageCell" om:@"setFont:" sm:@"hook_NSImageCell_setFont:"];
//    [self changeMethod: "NSImageView" om:@"setFont:" sm:@"hook_NSImageView_setFont:"];
//    [self changeMethod: "NSMenu" om:@"setFont:" sm:@"hook_NSMenu_setFont:"];
//    [self changeMethod: "NSScroller" om:@"setFont:" sm:@"hook_NSScroller_setFont:"];
//    [self changeMethod: "NSTextView" om:@"setFont:" sm:@"hook_NSTextView_setFont:"];
//    [self changeMethod: "RFOverlayScroller" om:@"setFont:" sm:@"hook_RFOverlayScroller_setFont:"];
//    [self changeMethod: "SVGButton" om:@"setFont:" sm:@"hook_SVGButton_setFont:"];


    
    // WeChat
//    [self changeMethod:"MMTextMessageCellView" om:@"init" sm:@"hook_MMTextMessageCellViewInit"];
//    [self changeMethod:"MMTextMessageCellView" om:@"setTextField:" sm:@"hook_MMTextMessageCellViewSetTextField:"];
    
//    [self changeMethod: "NSTextField" om:@"init" sm:@"hook_NSTextFieldInit"];
//    [self changeMethod: "NSAttributedString" om:@"initWithString:" sm:@"custom_initWithString:"];
//    [self changeMethod:"MMTimeStampCellView" om:@"initWithFrame:" sm:@"hook_MMTimeStampCellViewinitWithFrame:"];
//    [self changeMethod:"NSView" om:@"addSubview:" sm:@"hook_NSViewaddSubview:"];
//
//    [self changeMethod:"NSTableView" om:@"initWithFrame:" sm:@"hook_NSTableVIewinitWithFrame:"];
    
//    [self changeMethod:"MMTextMessageCellView" om:@"awakeFromNib" sm:@"hook_MMTextMessageCellView_awakeFromNib"];
}

/**
 获取指定类的属性

 @param cls 被获取属性的类
 @return 属性名称 [NSString *]
 */
-(NSArray *)getClassProperty:(Class)cls {

    if (!cls) return @[];

    NSMutableArray * all_p = [NSMutableArray array];

    unsigned int a;

    objc_property_t * result = class_copyPropertyList(cls, &a);

    for (unsigned int i = 0; i < a; i++) {
        objc_property_t o_t =  result[i];
        [all_p addObject:[NSString stringWithFormat:@"%s", property_getName(o_t)]];
    }

    free(result);

    return [all_p copy];
}

BOOL flag = NO;

/**
 获取指定类（以及其父类）的所有属性

 @param cls 被获取属性的类
 @param until_class 当查找到此类时会停止查找，当设置为 nil 时，默认采用 [NSObject class]
 @return 属性名称 [NSString *]
 */
-(NSArray *)getAllProperty:(Class)cls until_class:(Class)until_class {
//    if ([[cls className] isEqualToString:@"NSTextFieldCell"]) {
//        flag = YES;
//        NSLog(@"+++++++++++NSTextFieldCell start++++++++++\n");
//    }
//    if (flag == YES) {
//        NSLog(@"Current class:%@\n", [cls className]);
//    }
    Class stop_class = until_class ?: [NSObject class];

    if (cls == stop_class) return @[];

    NSMutableArray * all_p = [NSMutableArray array];

    [all_p addObjectsFromArray:[self getClassProperty:cls]];

    if (class_getSuperclass(cls) == stop_class) {
        return [all_p copy];
    } else {
        [all_p addObjectsFromArray:[self getAllProperty:[cls superclass] until_class:stop_class]];
    }

//    if ([[cls className] isEqualToString:@"NSTextFieldCell"]) {
//        NSLog(@"+++++++++++NSTextFieldCell end++++++++++\n");
//        flag = NO;
////        exit(1);
//    }
    return [all_p copy];
}

- (BOOL)hasProperty:(id)c propertyName:(NSString *)name {
    NSArray *names = [self getAllProperty:[c class] until_class:nil];
    if ([names containsObject:name]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)hook_MMTextMessageCellView_awakeFromNib {
    NSLog(@"=====MMTextMessageCellView-awakeFromNib start|class name:%@======\n", [self className]);
    if ([self hasProperty:self propertyName:@"font"]) {
        NSLog(@"OK get in");
        // 使用 KVC 设置属性值
        NSFont *f = (NSFont*)[self valueForKey:@"font"];
        [self setValue:[self generateFont:f.pointSize originalFont:f] forKey:@"font"];
    }
    [self hook_MMTextMessageCellView_awakeFromNib];
    NSLog(@"=====MMTextMessageCellView-awakeFromNib end======\n");
}

// not trrigered
- (NSTableView *)hook_NSTableVIewinitWithFrame:(NSRect)frameRect {
    NSLog(@"=====hook_NSTableVIew-initWithFrame start======\n");
    
    NSTableView * c = [self hook_NSTableVIewinitWithFrame:frameRect];
    NSLog(@"=====hook_NSTableVIew-initWithFrame end======\n");
    return c;
}

- (NSAttributedString *)custom_initWithString:(NSString *)str {
    NSLog(@"=====NSAttributedString-custom_initWithString start======\n");
    // 修改字体设置
    NSDictionary *attributes = @{NSFontAttributeName: [self generateFont:NSFont.systemFontSize originalFont:NULL]};
    NSAttributedString *modifiedString = [self custom_initWithString:str];
    NSAttributedString *customAttributedString = [[NSAttributedString alloc] initWithString:modifiedString.string attributes:attributes];
    NSLog(@"=====NSAttributedString-custom_initWithString end======\n");
    return customAttributedString;
}


- (void) changeNSTextFieldAttribute:(NSString *)propertyName obj:(MMMessageCellView *)view {
    NSLog(@"=====changeNSTextFieldAttribute start======\n");
    // 获取属性的值
    NSTextField *propertyValue = (NSTextField *)[view valueForKey:propertyName];
    // 获取字体
    NSFont *font = propertyValue.font;

    // 打印字体信息
    NSLog(@"Font: %@", font);
    NSLog(@"Font Family: %@", font.familyName);
    NSLog(@"Font Name: %@", font.fontName);
    NSLog(@"Font Size: %.2f", font.pointSize);
    NSFont *x = [view generateFont:font.pointSize originalFont:font];
    [propertyValue setFont:x];
    font = propertyValue.font;


    // 打印字体信息
    NSLog(@"+Font: %@", font);
    NSLog(@"+Font Family: %@", font.familyName);
    NSLog(@"+Font Name: %@", font.fontName);
    NSLog(@"+Font Size: %.2f", font.pointSize);
    NSLog(@"=====changeNSTextFieldAttribute end======\n");
}

- (void) changeNSTextViewAttribute:(NSString *)propertyName obj:(MMMessageCellView *)view {
    NSLog(@"=====changeNSTextViewAttribute start======\n");
    // 获取属性的值
    NSTextView *propertyValue = (NSTextView *)[view valueForKey:propertyName];
    // 获取字体
    NSFont *font = propertyValue.font;

    // 打印字体信息
    NSLog(@"Font: %@", font);
    NSLog(@"Font Family: %@", font.familyName);
    NSLog(@"Font Name: %@", font.fontName);
    NSLog(@"Font Size: %.2f", font.pointSize);
    NSFont *x = [view generateFont:font.pointSize originalFont:font];
    [propertyValue setFont:x];
    [propertyValue.textStorage setFont:x];
    NSTextField *f = [[NSTextField alloc] init];
    [f setFont:x];
    [view setTextField: f];
    // 确保 textStorage 的属性设置没有覆盖字体
    [propertyValue.textStorage setAttributedString:[[NSAttributedString alloc] initWithString:[x fontName]]];
    NSLog(@"xxxxx %@ \n", propertyValue.textStorage);
    font = [propertyValue font];
    NSLog(@"xxxxx %@ \n", x);
    
    // 打印字体信息
    NSLog(@"+Font: %@", font);
    NSLog(@"+Font Family: %@", font.familyName);
    NSLog(@"+Font Name: %@", font.fontName);
    NSLog(@"+Font Size: %.2f", font.pointSize);
    NSLog(@"=====changeNSTextViewAttribute end======\n");
}

// WeChat work
- (void)hook_NSViewaddSubview:(NSView *)view {
    NSLog(@"++hook_NSViewaddSubview+++ view:%@.\n", view);
    if ([[view className] isEqualToString:@"NSTextField"] || [[view className] isEqualToString:@"MMTextField"]) {
        NSTextField *x = (NSTextField *)view;
        [x setFont:[self generateFont:x.font.pointSize originalFont:x.font]];
        NSLog(@"The Font is:%@", ((NSTextField *)view).font);
        [x display];
        [table reloadData];
    }
    [self hook_NSViewaddSubview:view];
}


// WeChat work
- (id)hook_MMTimeStampCellViewinitWithFrame:(struct CGRect)arg1 {
    NSLog(@"++hook_MMTimeStampCellViewinitWithFrame+++ This is wechat method.\n");
    MMTimeStampCellView *m = [self hook_MMTimeStampCellViewinitWithFrame:arg1];
    [m changeNSTextFieldAttribute:@"_timeStampTextField" obj:m];
    NSTextField *f = [[NSTextField alloc] init];
    [f setFont:[self generateFont:NSFont.systemFontSize originalFont:NULL]];
    [m setTextField: f];
    NSLog(@"...........Font:%@ | _timeStampTextField.font:%@\n", m.textField, m.timeStampTextField.font);
//    [m changeNSTextFieldAttribute:@"waitingProgressLabel" obj:m]; crash
    
    
    [m setNeedsDisplay:YES];
    [m display];
    return m;
}

// WeChat work
- (id)hook_MMTextMessageCellViewinitWithFrame:(struct CGRect)arg1 {
    NSLog(@"++hook_MMTextMessageCellViewinitWithFrame+++ This is wechat method.\n");
    MMTextMessageCellView *m = [self hook_MMTextMessageCellViewinitWithFrame:arg1];
    [m changeNSTextFieldAttribute:@"solitaireTipsTextField" obj:m];
    [m changeNSTextFieldAttribute:@"groupChatNickNameLabel" obj:m];
    [m changeNSTextFieldAttribute:@"msgCreatetimeLabel" obj:m];
//    [m changeNSTextFieldAttribute:@"waitingProgressLabel" obj:m]; crash
    
    [m changeNSTextViewAttribute:@"translationBrandTextView" obj:m];
    
    NSLog(@"&Font :%@", m.translationBrandTextView.font);

    return m;
}

// NSTextField init, Error, not work
- (NSTextField *)hook_NSTextFieldInit {
    NSTextField *otf = [self hook_NSTextFieldInit];
    [otf setFont:[self generateFont:otf.font.pointSize originalFont:otf.font]];
    return otf;
}

// WeChat, work
- (id)hook_MMTextMessageCellViewInit {
    NSLog(@"++hook_MMTextMessageCellViewInit+++ This is wechat method, Current Class : %@\n", [self className]);
    if (![[self className] isEqualToString:@"NSTextField"]) {
        NSLog(@"++hook_MMTextMessageCellViewInit+++ Special class process : %@\n", [self className]);
        NSTextField * tf = [[NSTextField alloc] init];
        [tf setFont:[self generateFont:NSFont.systemFontSize originalFont:NULL]];
    }
    return [self hook_MMTextMessageCellViewInit];
}

// WeChat,work
- (void)hook_MMTextMessageCellViewSetTextField:(NSTextField*)otf {
    NSLog(@"++hook_MMTextMessageCellViewSetTextField+++ This is wechat method, Current Class : %@\n", [self className]);
    if ([[self className] isEqualToString:@"MMTextMessageCellView"]) {
        NSLog(@"++hook_MMTextMessageCellViewSetTextField+++ Special class process : %@\n", [self className]);
        [otf setFont:[self generateFont:otf.font.pointSize originalFont:otf.font]];
    }
    return [self hook_MMTextMessageCellViewSetTextField:otf];
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

- (NSFont*)generateFont:(const CGFloat)fontSize originalFont:(NSFont *)originalFont {
    NSLog(@"++++Original font name: %@", originalFont.fontName);
    if (originalFont != NULL && [originalFont.fontName containsString:(AppleColorEmoji)]) {
        return originalFont;
    }
    NSLog(@"++++Using JB font\n");
    return [NSFont fontWithName:@"JB-Mono-ND-MiS" size:fontSize];
}

// success
- (id)hook_fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSFont hook_FontWithName] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    return [self generateFont: fontSize originalFont:NULL];
}
// success
- (id)hook_fontWithName:(NSString *)fontName matrix:(const CGFloat *)fontMatrix {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSFont hook_FontWithName_matrix] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSCTFont *f = [self hook_fontWithName:fontName matrix:fontMatrix];
    return [self generateFont: f.pointSize originalFont:f];
}
// success
- (id)hook_fontWithDescriptor:(NSFontDescriptor *)fontDescriptor size:(CGFloat)fontSize {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSFont hook_FontWithDescriptor] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    return [self generateFont: fontSize originalFont:NULL];
}
// success
- (id)hook_systemFontOfSize:(CGFloat)fontSize {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSFont hook_systemFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    return [self generateFont: fontSize originalFont:NULL];
}
// success
- (id)hook_labelFontOfSize:(CGFloat)fontSize {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSFont hook_labelFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    return [self generateFont: fontSize originalFont:NULL];
}
// success
- (id)hook_menuFontOfSize:(CGFloat)fontSize {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSFont hook_menuFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    return [self generateFont: fontSize originalFont:NULL];
}
// success
- (id)hook_menuBarFontOfSize:(CGFloat)fontSize {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSFont hook_menuBarFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    return [self generateFont: fontSize originalFont:NULL];
}
// success
- (id)hook_messageFontOfSize:(CGFloat)fontSize {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSFont hook_messageFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    return [self generateFont: fontSize originalFont:NULL];
}
// success
- (id)hook_paletteFontOfSize:(CGFloat)fontSize {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSFont hook_paletteFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    return [self generateFont: fontSize originalFont:NULL];
}
// success
- (id)hook_toolTipsFontOfSize:(CGFloat)fontSize {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSFont hook_toolTipsFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    return [self generateFont: fontSize originalFont:NULL];
}
// success
- (id)hook_controlContentFontOfSize:(CGFloat)fontSize {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSFont hook_controlContentFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    return [self generateFont: fontSize originalFont:NULL];
}
// + (NSFont *)systemFontOfSize:(CGFloat)fontSize weight:(NSFontWeight)weight API_AVAILABLE(macos(10.11));
// success
- (id)hook_systemFontOfSize:(CGFloat)fontSize weight:(NSFontWeight)weight API_AVAILABLE(macos(10.11)) {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSFont hook_systemFontOfSize_withWeight] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    return [self generateFont: fontSize originalFont:NULL];
}
// success
- (id)hook_userFontOfSize:(CGFloat)fontSize {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSFont hook_userFontOfSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    return [self generateFont: fontSize originalFont:NULL];
}

// success
- (id)hook_fontWithSize:(CGFloat)fontSize {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSCTFont hook_fontWithSize] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    return [self generateFont: fontSize originalFont:NULL];
}
// success
- (id)hook_fontForAppearance:(id)i {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSCTFont hook_fontForAppearance] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    //    NSLog(@"\nxxxxxxxx: %@", [i className]);
    NSCTFont *f = [self hook_fontForAppearance:i];
    return [self generateFont: f.pointSize originalFont:f];
}
// success
- (id)hook_screenFont:(id)i {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSCTFont hook_screenFont] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSCTFont *f = [self hook_screenFont:i];
    return [self generateFont: f.pointSize originalFont:f];
}
// success
- (id)hook_verticalFont:(id)i {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSCTFont hook_verticalFont] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSCTFont *f = [self hook_verticalFont:i];
    return [self generateFont: f.pointSize originalFont:f];
}
// failed
- (id)hook_fontDescriptor {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSCTFont hook_fontDescriptor] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSCTFont *f = [self hook_fontDescriptor];
    return [self generateFont: f.pointSize originalFont:f];
}
// success
- (id)hook_displayName {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSCTFont hook_displayName] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSCTFont *f = [self hook_displayName];
    return [self generateFont: f.pointSize originalFont:f];
}
// success
- (id)hook_fontName {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSCTFont hook_fontName] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSCTFont *f = [self hook_fontName];
    return [self generateFont:f.pointSize originalFont: f];
}
// success
- (id)hook__similarFontWithName:(id)a {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[NSCTFont hook__similarFontWithName] current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
    NSCTFont *f = [self hook__similarFontWithName:a];
    return [self generateFont: f.pointSize originalFont:f];
}


// success
- (void)hook_NSTextField_setFont:(NSFont*)nf {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉[hook_NSTextField_setFont] current class:%@\nNSFont class name:%@, font name:%@\n", NSStringFromClass(currentClass), [nf className], [nf fontName]);
    //[self logParents];
//    NSFont *c = [NSFont fontWithName:@"Baskerville" size:NSFont.systemFontSize];
//    NSTextField *c = originalImp(self, originalClassMethodSel);
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_NSTextField_setFont:c];
    //NSLog(@"\n🎉 Call initialize method success\n");
    //NSLog(@"\nFinish~~\n");
}
// success
- (void)hook_NSTextFieldCell_setFont:(NSFont*)nf {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉 current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
//    NSFont *c = [NSFont fontWithName:@"Baskerville" size:NSFont.systemFontSize];
//    NSTextField *c = originalImp(self, originalClassMethodSel);
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_NSTextFieldCell_setFont:c];
    //NSLog(@"\n🎉 Call initialize method success\n");
    //NSLog(@"\nFinish~~\n");
}
// success
- (void)hook_NSButton_setFont:(NSFont*)nf {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉 current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
//    NSFont *c = [NSFont fontWithName:@"Baskerville" size:NSFont.systemFontSize];
//    NSTextField *c = originalImp(self, originalClassMethodSel);
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_NSButton_setFont:c];
    //NSLog(@"\n🎉 Call initialize method success\n");
    //NSLog(@"\nFinish~~\n");
}
// success
- (void)hook_NSMenuItem_setFont:(NSFont*)nf {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉 current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
//    NSFont *c = [NSFont fontWithName:@"Baskerville" size:NSFont.systemFontSize];
//    NSTextField *c = originalImp(self, originalClassMethodSel);
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_NSMenuItem_setFont:c];
    //NSLog(@"\n🎉 Call initialize method success\n");
    //NSLog(@"\nFinish~~\n");
}
// success
- (void)hook_NSTabViewItem_setFont:(NSFont*)nf {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉 current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
//    NSFont *c = [NSFont fontWithName:@"Baskerville" size:NSFont.systemFontSize];
//    NSTextField *c = originalImp(self, originalClassMethodSel);
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_NSTabViewItem_setFont:c];
    //NSLog(@"\n🎉 Call initialize method success\n");
    //NSLog(@"\nFinish~~\n");
}
// success
- (void)hook_NSLabel_setFont:(NSFont*)nf {
//    Class currentClass = [self class];
//    NSLog(@"\n🎉 current class:%@\n", NSStringFromClass(currentClass));
    //[self logParents];
//    NSFont *c = [NSFont fontWithName:@"Baskerville" size:NSFont.systemFontSize];
//    NSTextField *c = originalImp(self, originalClassMethodSel);
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_NSLabel_setFont:c];
    //NSLog(@"\n🎉 Call initialize method success\n");
    //NSLog(@"\nFinish~~\n");
}

// Test
- (void)hook_MMAvatarImageView_setFont:(NSFont*)nf {
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_MMAvatarImageView_setFont:c];
}

// Test
- (void)hook_MMButton_setFont:(NSFont*)nf {
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_MMButton_setFont:c];
}

// Test
- (void)hook_MMMessageUnreadTipsButton_setFont:(NSFont*)nf {
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_MMMessageUnreadTipsButton_setFont:c];
}

// Test
- (void)hook_MMOutlineButton_setFont:(NSFont*)nf {
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_MMOutlineButton_setFont:c];
}

// Test
- (void)hook_MMTextField_setFont:(NSFont*)nf {
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_MMTextField_setFont:c];
}
// Test
- (void)hook_NSButtonCell_setFont:(NSFont*)nf {
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_NSButtonCell_setFont:c];
}
// Test
- (void)hook_NSImageCell_setFont:(NSFont*)nf {
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_NSImageCell_setFont:c];
}
// Test
- (void)hook_NSImageView_setFont:(NSFont*)nf {
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_NSImageView_setFont:c];
}
// Test
- (void)hook_NSMenu_setFont:(NSFont*)nf {
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_NSMenu_setFont:c];
}

// Test
- (void)hook_NSScroller_setFont:(NSFont*)nf {
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_NSScroller_setFont:c];
}

// Test
- (void)hook_NSTextView_setFont:(NSFont*)nf {
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_NSTextView_setFont:c];
}

// Test
- (void)hook_RFOverlayScrollerj_setFont:(NSFont*)nf {
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_RFOverlayScrollerj_setFont:c];
}

// Test
- (void)hook_SVGButton_setFont:(NSFont*)nf {
    NSFont *c = [self generateFont: nf.pointSize originalFont:NULL];
    [self hook_SVGButton_setFont:c];
}

@end

static void __attribute__((constructor)) initialize(void) {
    static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [NSObject hookThunder];
        });
}
