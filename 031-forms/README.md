The example for this week is in two parts:

- `BestLatte` - the iOS app
- `best-latte-server` - a Rails API.  

The API is a submodule, so you'll have to update your submodules to retrieve it.

## Running the example locally

To get set up with the required code, clone the repository and then run:

```
git submodule update --init
```

This will fetch the server repository as well.  For more information
about running the server, visit the [best-latte-server](http://github.com/subdigital/best-latte-server)
repository.


## Configuring the iOS application to run against a local server

The iOS application has a hard-coded URL defined in `BLAPIClient.m`
which determines the base URL of the API to use.  If you'd like
to run this locally (or host your own version of it) then you'll have to
update this value.
