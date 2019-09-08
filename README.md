# Cachy

## Description
 
Nice threadsafe expirable cache management. Supports fetching from server, single object expire date, UIImageView loading etc.

## Installation

### Cocoapods

**CachyKit** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile: 

```ruby
pod 'CachyKit'
```
then run 

```
$ pod repo update
```
```
$ pod install
```

## Features

- [x] Asynchronous data downloading and caching.
- [x] Asynchronous image downloading, caching and showing.
- [x] Expiry date/time for all the object individually.
- [x] Multiple-layer hybrid cache for both memory and disk.
- [x] Fine control on cache behavior. Customizable expiration date and size limit.
- [x] Force refresh if needed.
- [x] Independent components. Use the Cachy or CachyLoader system separately as you need.
- [x] Can save JSON, UIImage, ZIP or AnyObject.
- [x] View extensions for `UIImageView`.
- [x] Indicator while loading images.


## Usage
If you want to download and cache a file(JSON, ZIP, UIImage or any type) then simply call with a url

```swift
 let cachy = CachyLoader()

 cachy.load(url: URL(string: "http://your_url_here")!) { [weak self] data, _ in
    // Do whatever you need with the data object
 }
```

You can also cache with **URLRequest**

```swift
let cachy = CachyLoader()

let url = URLRequest(url: URL(string: "http://your_url_here")!)
cachy.loadWith(urlRequest: url) { [weak self] data, _ in
    // Do whatever you need with the data object
 }
```

if you want set expiry date for each object 

```swift
let cachy = CachyLoader()

//(optional) if isRefresh = true it will forcefully refresh data from remote server
//(optional) you can set **expirationDate** according to your need

cachy.load(url: URL(string: "http://your_url_here")!,isRefresh = false,expirationDate = ExpiryDate.everyDay.expiryDate()) { [weak self] data, _ in
     // Do whatever you need with the data object
  }
```



**CachyLoader** has also UIImageView extension.

```swift
//(optional) if isShowLoading is true it will show a loading indicator
imageView.cachyImageLoad("your URL", isShowLoading: true, completionBlock: { _, _ in })
```

It will download, cache and load UIImage into your UIImageView
**CachyLoader** is also configurable, by calling function ***CachyLoaderManager.shared.configure()***

```swift
// All the parametre is optional
// Here if you want set how much much memory/disk should use set memoryCapacity, diskCapacity
// To cache only on memory set isOnlyInMemory which is true by default
// You may set expiry date for all the cache object by setting expiryDate

CachyLoaderManager.shared.configure(
	memoryCapacity: 1020, 
	diskCapacity: 2024, 
	maxConcurrentOperationCount: 10, 
	timeoutIntervalForRequest: 3,
	diskPath: "temp", 
	expiryDate: .weekly, 
	isOnlyInMemory: true
)
```

**expiryDate** parametre takes

1. **.never** to never expire the cache object
2. **.everyDay** to expire at the end of the day
3. **.everyWeek** to expiry after a week
4. **.everyMonth** to set the expiry date each month
5. **.seconds** to set the expiry after some seconds 


## Without CachyLoader

To cache using **CachyLoader** is the easiest way to do, but if you want manage your caching, sycning and threading **CachyKit** also supports that.

### Configuration

Here is how you can setup some configuration options

```swift
Cachy.countLimit = 1000 // setup total count of elements saved into the cache

Cachy.totalCostLimit = 1024 * 1024 // setup the cost limit of the cache

Cachy.shared.expiration = .everyDay // setup expiration date of each object in the cache

Cachy.shared.isOnlyInMemory = false // will be cached on Memory only or both

```


### Adding/Fetching objects

If you want to add or fetch an object you just follow these simple steps:

```swift
//1. Create a CachyObject
let object = CachyObject(value: "HEllo, Worlds", key: "key")

// A given expiry date will be applied to the item
let object2 = CachyObject(value: "HEllo, Worlds", key: "key",expirationDate: ExpiryDate.everyDay.expiryDate())

//2. Add it to the cache
Cachy.shared.add(object: object)

//3. Fetch an object from the cache
let string: String? = Cachy.shared.get(forKey: "key")
```

## Contact

Follow and contact me on [Twitter](http://twitter.com/sameesadman). If you find an issue, just [open a ticket](https://github.com/sadmansamee/Cachy/issues/new). Pull requests are warmly welcome as well.

## Contribution

If you want fix anything or improve or add any new feature you are very much welcome.

### License

Cachy is released under the MIT license. See LICENSE for details.


