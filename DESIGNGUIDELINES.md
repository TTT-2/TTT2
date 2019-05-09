# Design Guidelines of TTT2

The design style of TTT2 builds on top of the TTT design and therefore inherits some of the original designguidelines.

## Weapons and Perks

The style of the weapon and perk design is unchanged and [a template can be found here](http://ttt.badking.net/custom-weapon-guide). Additionally there are some information found in our [icon repository](https://github.com/TimGoll/ttt_addon_graphics/tree/master/reworked_shop/). Keep in mind that weapons should always use a blue background and perks a red background. This is done to prevent confusion while buying items in the shop.

After saving the finished icon as a png (64x64px), it has to be converted into a vtf file. The tool [vtf-edit](https://developer.valvesoftware.com/wiki/VTFEdit) helps with the conversion. There are some details about the parameters on the website with the icon template.

## Itemdisplay Sidebar Perk Icons

The icons are always white on a transparent background, no other colors or backgrounds are allowed. Additionally the icons have a padding of x pixels and are saved as a png with a resolution of 64x64px.

## Role Icons

Different to the shop icons the role icons do need mipmapping to allow for clean rescaling (TODO: more mipmapping filter information). Since the icons can be rendered quite large, they should be saved in a resolution of 512x512px. They are always white on transparent background without a shadow and a padding of x pixels.

## Workshop

TODO: Link example files of workshop designs
