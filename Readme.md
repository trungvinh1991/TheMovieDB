# TheMovieDB

TheMovieDB is an assignment of The Movie DB.

## Installation

### Cocoapods

Setup cocoapods

```bash
sudo gem install cocoapods
```

Then open terminal and point to the project folder

```bash
pod install
```

## Architecture
The project is using VIPER architecture

![Alt text](https://miro.medium.com/max/1354/1*HZIOzvXyvkpW4ytr2g0NvQ.png)

### View
The user interface, example: ViewController, View, etc ...

### Presenter
The “traffic cop” of the architecture, directing data between the view and interactor, taking user actions and calling to router to move the user between views

### Router
Handles navigation between screens

### Interactor 
A class that mediates between the presenter and the data, it takes direction from the presenter.

### Repository 
A class or component that encapsulate the logic required to access data sources

### Entity 
Represents application data

## Frameworks
The project is using Combine/RxSwift framework for handling async tasks.
With collectionview, project is used the newest components same as UICollectionViewCompositionalLayout, NSDiffableDataSourceSnapshot, UICollectionViewDiffableDataSource, ...

Note: Combine and newest components of collectionview only available iOS 13.0+

## License
Do what ever you want