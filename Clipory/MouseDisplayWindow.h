//
//  MouseDisplayWindow.h
//  Clipory
//
//  Created by Beroš Jurica on 12/3/11.
//  Copyright (c) 2011 Habitatus. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "MouseActivityView.h"

@interface MouseDisplayWindow : NSWindow

@property (weak) IBOutlet MouseActivityView *activityView;

- (void)setDisplayEvent:(NSEvent *)_event;

@end
