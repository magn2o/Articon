/**
 * This header is generated by class-dump-z 0.2a.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: /Library/MobileSubstrate/DynamicLibraries/IconOmatic.dylib
 */

@interface IconOmatic : NSObject <UIAlertViewDelegate, UITextViewDelegate> {
}
+(id)redrawIconWithOverlay:(id)overlay;
+(id)currentThemeName;
+(BOOL)isiPad;
+(BOOL)isRetina;
+(void)prefsHaveBeenChanged:(id)changed;
+(void)replacePrefsWithUserPrefs;
+(void)noUserDefaultsCreateNow;
+(BOOL)hasUserDefaults;
+(void)load;
+(id)sharedManager;
+(void)initialize;
@end
