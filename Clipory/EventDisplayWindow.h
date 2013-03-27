//
//  EventDisplayWindow.h
//  Clipory
//
//  Created by Beroš Jurica on 12/3/11.
//  Copyright (c) 2011 Habitatus. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface EventDisplayWindow : NSWindow <NSWindowDelegate> {
	BOOL shift;
	BOOL option;
	BOOL command;
}

@property (weak) IBOutlet NSTextField *displayTextField;

- (void)setDisplayEvent:(NSEvent *)_event;
- (void)clearTextField;

@end