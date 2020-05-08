# CS-Cart plugin for Paylike

This plugin is *not* developed or maintained by Paylike but kindly made
available by a user.

Released under the GPL V3 license: https://opensource.org/licenses/GPL-3.0

## Supported CS-Cart versions

* The plugin has been tested with most versions of CS-Cart at every iteration. We recommend using the latest version of CS-Cart, but if that is not possible for some reason, test the plugin with your CS-Cart version and it would probably function properly. 
* CS-Cart
 version last tested on: *4.11.1*

## Installation

  Once you have installed CS-Cart, follow these simple steps:
  1. Signup at [paylike.io](https://paylike.io) (it’s free)
  1. Create a live account
  1. Create an app key for your CS-Cart website
  1. Upload the plugin zip (`kp_paylike.zip`) trough the Add-ons panel and activate it
  1. Under Administration -> payment methods create a new payment method and select Paylike as the processor.
  1. On the configure tab, insert the app key and your public key in the settings for the Paylike payment gateway you just created
  

## Updating settings

Under the CS-Cart Paylike payment method settings, you can:
 * Update the title that shows up in the payment popup 
 * Add test/live keys
 * Set payment mode (test/live)
 * Change the Checkout Mode (Instant/Delayed)
 * Update the order status that trigger capture, void and what status the order gets in delayed mode
 
 ## How to
 
 1. Capture
 * In Instant mode, the orders are captured automatically
 * In delayed mode you can capture an order by moving the order to the completed/shipped status from processing. (This is based on your settings for the payment method) 
 2. Refund
   * For captured orders there is a refund button in the order details sidebar. Click and you will be able to refund an amount you can configure.
 3. Void
   * To void an order you can move the order into cancelled status. (This is based on your settings for the payment method) 
