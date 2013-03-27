//
//  StatusItemView.h
//  Clipory
//
//  Created by Jurica Beroš on 10/15/11.
//  Copyright (c) 2011 Habitatus. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StatusItemView : NSView {
	BOOL isHighlighted;
}

@property (assign) NSStatusItem *statusItem;
@property (nonatomic, retain) NSString *title;

- (void)windowDisplayed:(id)sender;
- (void)windowHidden:(id)sender;

@end
