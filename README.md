<p align="center">
  <h1 align="center">GreenNote</h1>
  <p align="center">An unofficial Grammarly Client for iPad</p>
</p>

## What is GreenNote?

<p align="center"><img style="width: 512px; max-width: 100%;" src="https://shumbo.github.io/GreenNote/images/mock.png"></p>

GreenNote is an unofficial Grammarly client for iPad, written in Swift. Just by installing the app and logging into your Grammarly account, your iPad will become a more powerful writing tool than ever before.

Technically, this app acts as a web browser that displays Grammarly web app. But the app injects some JavaScript code and CSS styles so that Grammarly works better on touch screens.

[<img src="https://shumbo.github.io/GreenNote/images/Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg">](https://itunes.apple.com/us/app/greennote-for-ipad/id1386842524?l=ja&ls=1&mt=8)

## Development

### Setup

This app is written in Swift. Once you have Xcode installed, start by cloning the repo.

```bash
$ git clone git@github.com:shumbo/GreenNote.git
$ cd GreenNote
```

You also need [Carthage](https://github.com/Carthage/Carthage) to resolve dependencies. Install it and run the following command to download and build them.

```bash
$ carthage checkout --platform iOS
```

Then, open `GreenNote.xcodeproj` to start development.

### Lint

This project uses [SwiftLint](https://github.com/realm/SwiftLint). Run `swiftlint ` on the root of the project to lint code.

If you have SwiftLint installed, Xcode will also point out errors on the editor.

## License

[MIT Licensed.](https://github.com/shumbo/GreenNote/blob/master/LICENSE)

## Support

If you have any questions, bugs or feature requests, please feel free to create issues or pull requests :smile:
