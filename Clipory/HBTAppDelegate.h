//
//  HBTAppDelegate.h
//  Clipory
//
//  Created by Jurica Beroš on 10/15/11.
//  Copyright (c) 2011 Habitatus. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSCustomWindow.h"
#import "EventDisplayWindow.h"
#import "MouseDisplayWindow.h"

@interface HBTAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, NSMenuDelegate> {
	BOOL _isMonitoring;
	id _eventHandler;
	id _mouseEventHandler;
}

@property (assign) IBOutlet NSCustomWindow *window;
@property (assign) IBOutlet NSMenu *popupMainMenu;
@property (retain) NSStatusItem *statusBarItem;
@property (weak) IBOutlet NSButton *startButton;
@property (unsafe_unretained) IBOutlet EventDisplayWindow *displayWindow;
@property (unsafe_unretained) IBOutlet MouseDisplayWindow *passThrough;



- (void)initStatusBarItem;
- (void)statusBarItemClicked:(id)sender;
- (IBAction)startStopClicked:(id)sender;

@end
