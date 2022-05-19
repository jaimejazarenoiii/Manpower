# Manpower

### Technology
* MVVM
* RxSwift
* Coordinator pattern
* Input/Output/Types view model pattern


### References
* [MVVM’s view model architecture with Reactive Programming](https://medium.com/@jaimejazarenoiii/mvvms-view-model-architecture-with-reactive-programming-88f8deb89184)

## Coordinators
Will handle the navigation of a certain flow, navigation by means pushing, presenting, dismissing and popping. 

## Flow

Continuous stream of navigation of view controllers.
E.g
* . This is considered as one flow so we group it into one coordinator.
![OnboardingCoordinator](https://i.imgur.com/cRM7XCK.png)
* When do we separate it to another coordinator? If it has its own flow inside. Like this one:
![SignupCoordinator](https://i.imgur.com/71uvJdf.png)
Earlier, we put the signup page inside onboarding coordinator, because it doesn't have its own flow, it's considered a page inside of onboarding flow, but now since the sign up page has multiple screens due to multiple steps for signing up, we can now separate it to a new coordinator.

* Diagram -> https://app.creately.com/d/qJJXVSLX6VJ/
