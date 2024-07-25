## Item Drop Script

This resource is an item drop script that enhances gameplay by introducing a dynamic loot-drop system. When a player uses one of the specified satellite phones (Golden, Red, or Green), they initiate contact with a pilot. This pilot will then drop a crate from a plane, delivering valuable loot.

### How It Works
1. **Initiate Contact**: Using any of the designated satellite phones will send a signal to the pilot.
2. **Crate Drop**: The pilot receives the signal and prepares a crate to be dropped from the plane.
3. **Crate Descent**: The crate will descend to the ground, giving players a visual cue to locate it.
4. **Collect the Loot**: Once the crate reaches the ground, players can interact with it using the targeting system to collect the valuable loot contained inside.

### Features
- **Realistic Interaction**: The use of satellite phones adds a layer of realism and immersion to the game.
- **Dynamic Loot Drops**: Each crate drop is unique, providing a varied gameplay experience.
- **Target System Integration**: Seamlessly interact with the crate using the interact system to collect your loot.
- **Engaging Gameplay**: Adds excitement and strategic elements as players wait for and secure the dropped loot.

This script is perfect for servers looking to enhance their gameplay with interactive and rewarding loot-drop events.

# Dependencies:

- [qbx_core](https://github.com/Qbox-Project/qbx_core)
- [interact by darktrovx](https://github.com/darktrovx/interact) 

# How to Install

- Add the images in the folder to your ox_inventory/web/images

- Add the below items to ox_inventory/data/items.lua

```lua
['goldenphone'] = {
    label = 'Golden Satellite Phone',
    weight = 200,
    stack = true,
    close = false,
    description = 'A communication device used to contact mocro mafia.',
    client = { image = 'goldenphone.png' }
},

['redphone'] = {
    label = 'Red Satellite Phone',
    weight = 200,
    stack = true,
    close = false,
    description = 'A communication device used to contact mocro mafia.',
    client = { image = 'redphone.png' }
},

['greenphone'] = {
    label = 'Green Satellite Phone',
    weight = 200,
    stack = true,
    close = false,
    description = 'A communication device used to contact mocro mafia.',
    client = { image = 'greenphone.png' }
}
```
