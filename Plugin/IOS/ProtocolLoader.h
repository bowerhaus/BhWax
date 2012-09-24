// Many protocols will work from wax out of the box. But some need to be preloaded.
// If the protocol you are using isn't found, just add the protocol to this object
//
// This seems to be a bug, or there is a runtime method I'm unaware of

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface ProtocolLoader : NSObject <UIApplicationDelegate, UIWebViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UISearchBarDelegate, UITextViewDelegate, UITabBarControllerDelegate, UISearchDisplayDelegate,
        GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventHandlerDelegate> {}
@end

@implementation ProtocolLoader
@end
