# Babylon
### Demo - George Kaimakas

## What
The following project is my implementation of the Babylon demo project. The project is structured under the MVVM pattern with some modifications. Most notable is the introduction of another target dependency (BabylonCommon). BabylonCommon hold common structures, enums, extensions that can be leveraged by every other target/framework in the project.

The rest of the project consists of 3 targets and the main app. Each target is only aware of only its' direct previous target and BabylonCommon (e.g BabylonViews is only aware of BabylonViewModels and BabylonCommon).

The project implements my current interpretation of what SOLID should be.

### BabylonModels
Used for fetching data from a remote location (backend) or the local storage. It is also responsible for persisting any data locally.

Responsible for requesting and/or persisting data is a provider. Providers come in three flavours:

1. local
2. remote
3.  plain (without a suffix).

Local providers are responsible for fetching data from the local storage and saving/updating said data.

Remote providers are responsible for fetching data from the backend and decoding them in the necessary data structs. Since jsonplaceholder uses a simple json structure, codable was used for the decoding.

Plain providers (e.g PostProvider) combine functionality from both local and remote providers. The user can specify the origin of the data using `FetchStrategy`. Returned data from a plain provider are wrapped inside a `FetchResult` struct.

BabylonModels also provides provider protocols. A provider conforms to a provider protocol. BabylonModels provides default implementations for each provider protocol which are actually used for the actual app. Every other target of the project does not use any provider directly, instead the use provider protocol conforming objects.

The naming of each provider and the fact that there are some many is intentional. First of all it makes it clear what every provider does but also it makes easier for many people to make changes simultaneously in different branches with minimal conflicts.

Also, internal implementation details do not leak to the outside world. One such example is that no CoreData ManagedObjects are public and only immutable structs are visible to the outside world. This enables the app to swap persistence frameworks without changes rippling through the whole app.

### BabylonViewModels

Where the business rules are applied. Every view model is a class enabling it to be shared and changes made in one place to ripple throughout the app.  The naming of each view model implies its' function, e.g PostListViewModels are only responsible for fetching posts.

Each viewModel is responsible for keeping its internal state (single responsiblity), e.g the comments that are made on a post are kept in the PostViewModel. ViewModels make use of ReactiveSwift's Property/MutableProperty and Action.

### BabylonViews

Normally I would mix .xib files with code implementation of views but lately I think that creating a view entirely from code is faster and easier when organizing the project (half the files) therefore in this target all views are made from code using SnapKit.

Every view is configured by applying a driver (I must have seen the name somewhere in RxSwift and copied it). A `Driver` is a protocol conforming class. Usually view models conform to a driver protocol (the conformance is done in BabylonViews since BabylonViewModels is not aware of BabylonViews). I find it easier to extend a viewModel to conform to a driver protocol inside the view's swift file (something that generally is a violation of how I structure my extensions but it makes discoverability for me and others easier).

#### Diffing

`DiffingDataSource` is the base class used for diffing. Diffing for TableViews is done in `UITableViewDiffingDataSource`

`TableViewDataPresenter` is a base class conforming to `UITableViewDataSource` and `UITableViewDelegate`

### Babylon

The main app. The most notable class there is `DependencyContainer` where the actual DI is done for every provider and view model using `Swinject`. Most use cases for DependencyInjection in this app are trivial so a simpler approach could be used but since I wanted to showcase how i structure my apps,  i've included it either way.

Something I should change here too is that I should probably use the driver approach in view controllers as I do in views.

## Tests

Since most of the app is structured on protocol, testing, mocking etc is pretty straightforward. I opted to provide example test cases for models and view models in this demo.


### Models

I provide some test case examples for UserLocalProvider and UserRemoteProvider.

For the local provider I create a new data store (specific for the test case) and proceed in testing some basic functionality of the provider.

To test the remote provider, I needed to stub url responses. Since `Network` that `RemoteProvider` uses is a protocol, providing a different implementation is easy.

### ViewModels

Testing view models took a bit more writing since there are 3 providers that needed to be stubbed (I should probably change the name of to stubbed instead of mocked). The use case here is straightforward so I decided to only check that when the request responds with x objects, they are assigned to the comments property.
