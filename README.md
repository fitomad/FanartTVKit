# FanartTVKit
Fanart.TV API written in Swift.

The [Fanart.TV][http://fanart.tv] is the best place to find images related to movies, shows or music. First of all you have to obtain an [API Key][https://fanart.tv/get-an-api-key/]. Read [API documentation][http://docs.fanarttv.apiary.io/#] it's a really good idea.

##Usage
The API's entry is the `FanartClient`class that contains methods to ask for Movies, TV Shows and Music related images. In lines below you can see an example of a request for the **Suits** TV Show

```swift
FanartClient.sharedInstance.fanartForShow(247808) { (show, error) -> (Void) in
    if let show = show
    {
        print("#\(show.showName)")
                
        if let backgrounds = show.backgrounds where !backgrounds.isEmpty
        {
            if let langs = backgrounds.languagesAvailables
            {
                print(langs)
            }
        }
    }
    else
    {
        print("#El show no existe")
    }
}
```

##Contact
If have any question or suggestion feel free to contact me at [@fitomad][https://twitter.com/fitomad] on Twitter.
