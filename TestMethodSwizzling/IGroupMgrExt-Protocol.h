//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Sep 17 2017 16:24:48).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

@class NSArray, NSString;

@protocol IGroupMgrExt

@optional
- (void)OnAddGroupMember:(NSString *)arg1 withStatus:(unsigned int)arg2 memberList:(NSArray *)arg3 contactList:(NSArray *)arg4;
- (void)OnChangeMemberShowDisplayName:(NSString *)arg1;
- (void)OnDelGroupMember:(NSString *)arg1 withResult:(unsigned int)arg2 memberList:(NSArray *)arg3;
- (void)OnModifyGroupMemberContact:(NSArray *)arg1;
- (void)OnQuitGroup:(NSString *)arg1;
- (void)OnQuitGroupUIAction:(NSString *)arg1 withResult:(BOOL)arg2 errorMsg:(NSString *)arg3 deleteAllMsg:(BOOL)arg4;
@end
