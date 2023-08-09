#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>

__attribute__((visibility("hidden")))
@interface AIListController : PSListController
- (id)specifiers;
@end

@implementation AIListController

- (id)specifiers
{
	if(_specifiers == nil)
		_specifiers = [[self loadSpecifiersFromPlistName:@"Articon" target:self] retain];

	return _specifiers;
}

- (void)launchTwitter:(id)specifier
{
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/magn2o"]];
	else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/magn2o/"]];
}

@end
