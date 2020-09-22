#import <Cocoa/Cocoa.h>

#import "DemoView.h"

#import <string>

@interface DemoApplicationDelegate : NSObject
@end

@implementation DemoApplicationDelegate
	- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
	{
		return YES;
	}
@end

void macOSQuit()
{
	[NSApp terminate:NSApp];
}

void macOSSetWindowTitle(void * view, const char * title)
{
	DemoView * nsView = reinterpret_cast< DemoView * >( view );
	[nsView setWindowTitle:title];
}

void macOSMain()
{
	[NSAutoreleasePool new];
	id app = [NSApplication sharedApplication];
	[app setActivationPolicy:NSApplicationActivationPolicyRegular];

	// Create window
	NSRect wndFrame = NSMakeRect(0, 0, 1280, 720);
	id window  = [[[NSWindow alloc]
		initWithContentRect:wndFrame
		styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable
		backing:NSBackingStoreBuffered
		defer:NO] autorelease];
	[window cascadeTopLeftFromPoint:NSMakePoint(10, 10)];
	[window setBackgroundColor:[NSColor blueColor]];
	[window makeKeyAndOrderFront:nil];

	// Since Snow Leopard, programs without application bundles and Info.plist files don't get a menubar 
	// and can't be brought to the front unless the presentation option is changed
	[app setActivationPolicy:NSApplicationActivationPolicyRegular];
	
	// Create Metal compatible view
	DemoView * view = [[[DemoView alloc] initWithFrame:wndFrame] autorelease];
	[window setAcceptsMouseMovedEvents:YES];
	[window setContentView:view];
	[window setDelegate:view];

	id appDelegate =[DemoApplicationDelegate new];
	[app setDelegate: appDelegate];
	[app activateIgnoringOtherApps:YES];
	[app setActivationPolicy:NSApplicationActivationPolicyRegular];

	[app run];
}
