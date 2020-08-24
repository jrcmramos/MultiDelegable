# Description

Support for multiple delegate weak references using `NSHashTable<AnyObject>.weakObjects()`.

# Usage
```Swift
// Provider
final class ProjectsProvider: MultiDelegable {
    public let delegateStore = DelegateStore<ProjectsProviderDelegate>()
}

// Client
final class ProjectsOverviewViewModel: ProjectsProviderDelegate {
    let projectsProvider: ProjectsProvider

    init(projectsProvider: ProjectsProvider) {
        self.projectsProvider = projectsProvider
        
        projectsProvider.addDelegate(self)
    }
}
```