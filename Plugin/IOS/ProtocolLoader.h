// Many protocols will work from wax out of the box. But some need to be preloaded.
// If the protocol you are using isn't found, just add the protocol to this object
//
// This seems to be a bug, or there is a runtime method I'm unaware of

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <MessageUI/MFMailComposeViewController.h>

// AWB: 25/9/12 - Introduced alternative format for generating these extenal protocol references.
// Using this method we can avoid irritaing compiler warnings about unimplemewnted protocols.

BOOL wax_protocol_loader(void);

BOOL wax_protocol_loader() {
    return
         @protocol(UIApplicationDelegate) &&
         @protocol(UIWebViewDelegate) &&
         @protocol(UIActionSheetDelegate) &&
         @protocol(UIAlertViewDelegate) &&
         @protocol(UISearchBarDelegate) &&
         @protocol(UITextViewDelegate) &&
         @protocol(UITabBarControllerDelegate) &&
         @protocol(UISearchDisplayDelegate) &&
    
         @protocol(MFMailComposeViewControllerDelegate) &&
    
         @protocol(GKTurnBasedMatchmakerViewControllerDelegate) &&
         @protocol(GKTurnBasedEventHandlerDelegate) &&
         @protocol(GKTurnBasedMatchmakerViewControllerDelegate);
}