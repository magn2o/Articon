#import "headers.h"
#import "IconOmatic.h"

#define kArticonPrefs @"/private/var/mobile/Library/Preferences/com.fortysixandtwo.articon.plist"

static BOOL isEnabled = YES;
static BOOL shouldClearArtwork = YES;
static BOOL isUsingIconomatic = NO;

static unsigned int labelText = 0;

static id nowPlayingApplication = nil;

static NSString *nowPlayingBundleIdentifier;

@interface SBApplication (Articon)
- (id)articonLabelName;
@end

%hook SBApplication
%new(@@:)
- (id)articonLabelName
{
    NSString *_articonLabelName = nil;
    SBMediaController *mediaController = [%c(SBMediaController) sharedInstance];
    
    NSString *defaultDisplayName = [[[nowPlayingApplication bundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    switch(labelText)
    {
        case 3:
        {
            _articonLabelName = [mediaController nowPlayingAlbum];
            break;
        }
            
        case 2:
        {
            _articonLabelName = [mediaController nowPlayingTitle];
            break;
        }
            
        case 1:
        {
            _articonLabelName = [mediaController nowPlayingArtist];
            break;
        }
            
        default: _articonLabelName = defaultDisplayName;
    }

    return [mediaController isPlaying] || [mediaController isPaused] ? _articonLabelName : defaultDisplayName;
}
%end

%hook SpringBoard
- (void)setNowPlayingInfo:(id)arg1 forApplication:(id)arg2
{
    %log;
    %orig;

    if(isEnabled)
    {
        id _nowPlayingApplication = nowPlayingApplication;
        nowPlayingApplication = arg2;

        NSString *_nowPlayingBundleIdentifier = nowPlayingBundleIdentifier;
        nowPlayingBundleIdentifier = [nowPlayingApplication bundleIdentifier];

        SBIcon *icon = nil;
        
        if(![_nowPlayingBundleIdentifier isEqualToString:nowPlayingBundleIdentifier])
        {
            icon = [[[%c(SBIconViewMap) homescreenMap] iconModel] applicationIconForDisplayIdentifier:_nowPlayingBundleIdentifier];
            
            if(shouldClearArtwork)
            {
                [icon reloadIconImagePurgingImageCache:YES];
            }
            
            [_nowPlayingApplication setDisplayName:[[[_nowPlayingApplication bundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
            [[[%c(SBIconViewMap) homescreenMap] iconViewForIcon:icon] _updateLabel];
        }
        
        icon = [[[%c(SBIconViewMap) homescreenMap] iconModel] applicationIconForDisplayIdentifier:nowPlayingBundleIdentifier];
        [icon reloadIconImagePurgingImageCache:YES];
        
        [nowPlayingApplication setDisplayName:[nowPlayingApplication articonLabelName]];
        [[[%c(SBIconViewMap) homescreenMap] iconViewForIcon:icon] _updateLabel];
    }
}
%end

%hook SBIcon
- (id)getIconImage:(int)arg1
{
    if(isEnabled)
    {
        if([[self applicationBundleID] isEqualToString:nowPlayingBundleIdentifier])
        {
            SBMediaController *mediaController = [%c(SBMediaController) sharedInstance];
            UIImage *image = [[mediaController artwork] _applicationIconImageForFormat:2 precomposed:YES];
            
            if(image)
            {
                if(isUsingIconomatic && [%c(IconOmatic) respondsToSelector:@selector(redrawIconWithOverlay:)])
                {
                    return [%c(IconOmatic) redrawIconWithOverlay:image];
                }
                
                return image;
            }
            
            return %orig;
        }
    }

    return %orig;
}
%end

static void loadSettings(void)
{
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:kArticonPrefs];

    if([settings objectForKey:@"isEnabled"]) isEnabled = [[settings objectForKey:@"isEnabled"] boolValue];
    if([settings objectForKey:@"shouldClearArtwork"]) shouldClearArtwork = [[settings objectForKey:@"shouldClearArtwork"] boolValue];
    if([settings objectForKey:@"labelText"]) labelText = [[settings objectForKey:@"labelText"] intValue];
    
    [settings release];
}

static void reloadPrefsNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    loadSettings();
    
    if(nowPlayingBundleIdentifier)
    {
        SBIcon *icon = [[[%c(SBIconViewMap) homescreenMap] iconModel] applicationIconForDisplayIdentifier:nowPlayingBundleIdentifier];
        [icon reloadIconImagePurgingImageCache:YES];

        [[[%c(SBIconViewMap) homescreenMap] iconViewForIcon:icon] _updateLabel];
    }
}

%ctor
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    %init;
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)&reloadPrefsNotification, CFSTR("com.fortysixandtwo.articon/settingschanged"), NULL, 0);
    
    if(dlopen("/Library/MobileSubstrate/DynamicLibraries/IconOmatic.dylib", RTLD_NOW) != NULL)
    {
        isUsingIconomatic = YES;
    }

    loadSettings();
    [pool drain];
}
