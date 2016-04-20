//
//  BLCAwesomeFloatingToolbar.h
//  BlocBrowser
//
//  Created by Inioluwa Work Account on 20/04/2016.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLCAwesomeFloatingToolbar;

@protocol BLCAwesomeFloatingToolbarDelegate <NSObject>

@optional

-(void) floatingToolbar:(BLCAwesomeFloatingToolbar*)toolbar didSelectButtonWithTitle:(NSString *)title;

@end



@interface BLCAwesomeFloatingToolbar : UIView

/**
 * @brief initializes the UIView object descendant floating toolbar with four (NSString) titles;
 * @warning Please note that the titles NSArray should take no more than 4 objects
 * @param titles NSArray of array.size/array.length = 4
 * @return A visual UIView object with 4 blocks and a title for each respective block
 */
 - (instancetype) initWithFourTitles:(NSArray *)titles;


/**
 * @brief This is a delegate method to allow other classes to either enable or disable a particular button with a title
 * @param enabled set whether button with title from variable @"title" is enabled or disabled (BOOL)
 * @param title determines which specific button out of the four buttons in the view should be enabled or disabled (depending on what @"enabled" is set to)
 * @return void
 */
 - (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;


///@brief the delegate for this class - if one is ever initialized
@property (nonatomic, weak) id <BLCAwesomeFloatingToolbarDelegate> delegate;


@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, weak) UILabel *currentLabel;

@end
