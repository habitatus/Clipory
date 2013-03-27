//
//  HBTAppDelegate.m
//  Clipory
//
//  Created by Jurica Beroš on 10/15/11.
//  Copyright (c) 2011 Habitatus. All rights reserved.
//

#import "HBTAppDelegate.h"
#import "StatusItemView.h"

@implementation HBTAppDelegate
@synthesize startButton;
@synthesize displayWindow;
@synthesize passThrough;

@synthesize window = _window, statusBarItem, popupMainMenu;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
	[self initStatusBarItem];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarItemClicked:) name:kNotificationStatusItemClicked object:nil];
	
	_isMonitoring = NO;
	
	[passThrough setIgnoresMouseEvents:YES];
	
	
	[[NSUserDefaults standardUserDefaults] addObserver:self
											forKeyPath:@"kKeyboardEvents"
											   options:NSKeyValueObservingOptionNew
											   context:NULL];

	[[NSUserDefaults standardUserDefaults] addObserver:self
											forKeyPath:@"kMouseEvents"
											   options:NSKeyValueObservingOptionNew
											   context:NULL];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if([defaults boolForKey:@"kKeyboardEvents"]) {
		[displayWindow makeKeyAndOrderFront:self];
	} else {
		[displayWindow orderOut:self];
	}
	if([defaults boolForKey:@"kMouseEvents"]) {
		[passThrough makeKeyAndOrderFront:self];
	} else {
		[passThrough orderOut:self];
	}
}

- (void)initStatusBarItem
{
	NSStatusBar *bar = [NSStatusBar systemStatusBar];	
	statusBarItem = [bar statusItemWithLength:NSVariableStatusItemLength];
	statusBarItem.highlightMode = YES;
	
	StatusItemView *itemButton = [[StatusItemView alloc] initWithFrame:NSMakeRect(0.0, 0.0, [statusBarItem length], [[statusBarItem statusBar] thickness])];
	
	itemButton.statusItem = statusBarItem;
	statusBarItem.view = itemButton;
	itemButton.title = @"Clipory";
	
//	NSMenu *menu = [[NSMenu alloc] init];
//	menu.delegate = self;
//	
//	statusBarItem.menu = menu;
}

- (void)statusBarItemClicked:(id)sender
{
	if([[NSApplication sharedApplication] isActive] && [self.window isKeyWindow]) {
		[self windowDidResignKey:nil];
		return;
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWindowDisplayed object:nil];
	
	NSRect itemRect = [statusBarItem.view.window frame];
	NSPoint itemPoint = itemRect.origin;
	itemPoint.x += itemRect.size.width / 2;
	itemPoint.x -= self.window.frame.size.width / 2;
	itemPoint.y = [[NSScreen mainScreen] frame].size.height - itemRect.size.height - self.window.frame.size.height;
	[self.window setFrameOrigin:itemPoint];
	
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];	
	[self.window makeKeyAndOrderFront:self];
}

- (void)windowDidResignKey:(NSNotification *)notification {
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWindowHidden object:nil];
	[self.window close];
	[[NSApplication sharedApplication] deactivate];
}

- (IBAction)startStopClicked:(id)sender {
	
	if(_isMonitoring) {
		[NSEvent removeMonitor:_eventHandler];
		[NSEvent removeMonitor:_mouseEventHandler];
		_isMonitoring = NO;
		[startButton setTitle:@"Start"];
	} else {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		_eventHandler = [NSEvent addGlobalMonitorForEventsMatchingMask:(NSKeyDownMask | NSFlagsChangedMask) 
											   handler:^(NSEvent *event) {
												   if([defaults boolForKey:@"kKeyboardEvents"]) {
													   [displayWindow setDisplayEvent:event];
												   }
											   }];
		_mouseEventHandler = [NSEvent addGlobalMonitorForEventsMatchingMask:(NSLeftMouseDownMask | NSLeftMouseUpMask | NSLeftMouseDraggedMask | NSRightMouseDownMask | NSRightMouseUpMask) 
															   handler:^(NSEvent *event) {
																   if([defaults boolForKey:@"kMouseEvents"]) {
																	   [passThrough setDisplayEvent:event];
																   }
															   }];
		_isMonitoring = YES;
		[startButton setTitle:@"Stop"];
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
					  ofObject:(id)object 
						change:(NSDictionary *)change 
					   context:(void *)context {

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if([defaults boolForKey:@"kKeyboardEvents"]) {
		[displayWindow makeKeyAndOrderFront:self];
	} else {
		[displayWindow orderOut:self];
	}
	if([defaults boolForKey:@"kMouseEvents"]) {
		[passThrough makeKeyAndOrderFront:self];
	} else {
		[passThrough orderOut:self];
	}


	if(_isMonitoring) {
		[self startStopClicked:nil];
		[self startStopClicked:nil];
	}
}

@end
