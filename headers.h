@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (id)artwork;
- (id)nowPlayingApplication;
- (id)nowPlayingArtist;
- (id)nowPlayingTitle;
- (id)nowPlayingAlbum;
- (_Bool)isPlaying;
- (_Bool)isPaused;
@end

@interface SBIcon : NSObject
- (id)application;
- (id)applicationBundleID;
- (void)reloadIconImagePurgingImageCache:(BOOL)arg1;
@end

@interface SBIconModel : NSObject
- (id)applicationIconForDisplayIdentifier:(id)arg1;
@end

@interface SBIconViewMap : NSObject
+ (id)homescreenMap;
- (id)iconModel;
- (id)iconViewForIcon:(id)arg1;
@end

@interface SBApplication : NSObject
- (id)bundleIdentifier;
- (id)displayName;
- (id)defaultDisplayName;
- (void)setDisplayName:(id)arg1;
- (void)setDefaultDisplayName:(id)arg1;
- (id)articonLabelName;
- (id)bundle;
@end

@interface SBIconView : UIView
- (void)_updateLabel;
@end

@interface UIImage (UIApplicationIconPrivate)
- (id)_applicationIconImageForFormat:(int)arg1 precomposed:(BOOL)arg2;
@end
