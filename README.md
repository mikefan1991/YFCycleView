# YFCycleView
A cycle view that has two different showing style with auto scroll property

Usage:
import "YFCycleView.h"

Note:
1. If you need to use images from the internet, you have to import the SDWebImage SDK in your project since the image download is dependent on this library.
2. Because it is a cycle view, it is better for you to at least have more than three items, especially for the YFCycleViewSytleExhibit.
3. I didn't add any other views on the imageView of each item. If you want to show some information like UILabel, you can just add them on the imageView. I might change the name of imageView to contentView later.
