SKScene

Apple has made avaliable the SpriteKit template and I have re-used this template code for this ProtoType test. 

The goal here was to test multiple scenes being delegated by a parent view controller. 

I manually create three buttons inside of the view controller to navigate the scenes. 

ARC is enabled and doing all of the trash cleanup. 

Profile tests pass with 100 SKAction spaceship nodes at 25FPS.

Another update: 5/30/14

Added scrolling background and object prototypes
Added TableView, customized with dynamic data via HTTP
*Hint: It might help having some remote data access to avoid forcing updates for general information needs
*Note: If you want to reuse the API call to Google, use your own API key!!!