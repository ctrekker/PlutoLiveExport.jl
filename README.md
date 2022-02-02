# PlutoLiveExport.jl

Keep an updated export of every notebook you edit for quick viewing and publishing! 🚀

## Installation

_Coming to general registry soon!_

```julia
(@v1.7) pkg> add https://github.com/ctrekker/PlutoLiveExport.jl
```

## Usage

Use the following code to start Pluto instead of the standard `Pluto.run` way.

```julia
using Pluto, PlutoLiveExport
Pluto.run(; on_export=live_export())
```

_Make sure to call `live_export` as a function (`live_export()`)_

By default this will automatically make exports to `HOME/Documents/Pluto Exports` every time you make a change in a notebook. You can change where these exports get placed by providing a path to the `export_path` keyword argument.

```julia
using Pluto, PlutoLiveExport
Pluto.run(; on_export=live_export(; export_path = "/my/special/export/path"))
```

## Export Configuration

The only positional argument of `live_export` is `format`, which can be used to switch export formats from the default of HTML. The currently supported export formats are:

- html
- statefile

As an example, to export to statefiles we would use `live_export("statefile")`.

> _[what's a statefile??](about:blank)_

To export into multiple formats simultaneously, pass a vector of formats instead.

```julia
live_export(["html", "statefile"])
```

### Keyword Arguments

List of keyword arguments for `live_export`:

- `export_path` - Folder that exports are saved in
- _that's it for now :)_
