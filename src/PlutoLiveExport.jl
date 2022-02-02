module PlutoLiveExport

import Pluto, HTTP, SHA

export live_export


_format_map = Dict(
    "html" => "/notebookexport",
    "statefile" => "/statefile"
)

# change this when the PR is merged
_export_url(nb::Pluto.Notebook, endpoint::String) = "http://localhost:1234$(endpoint)?id=$(string(nb.notebook_id))"


function save_export(format::String, root_save_path::String, nb::Pluto.Notebook, export_data::Vector{UInt8})
    static_notebook_hash = bytes2hex(SHA.sha256(nb.path))
    nbname = basename(nb.path)
    if endswith(nbname, ".jl")
        nbname = nbname[1:end-3]
    end
    format_export_path = joinpath(root_save_path, format)
    if !isdir(format_export_path)
        mkdir(format_export_path)
    end
    save_path = joinpath(format_export_path, "$(nbname) $(static_notebook_hash[1:8]).$(format)")

    # actually publish the notebook
    open(save_path, "w") do io
        write(io, export_data)
    end
end


function live_export(format::String = "html"; export_path = joinpath(homedir(), "Documents", "Pluto Exports"))
    if !isdir(export_path)
        mkdir(export_path)
    end

    # make this an alias of "statefile" because I can see them getting confused
    if format == "state"
        format = "statefile"
    end

    if !haskey(_format_map, format)
        throw(ErrorException("Unknown export format \"$(format)\". Available formats are $(keys(_format_map))"))
    end

    function on_pluto_event(e::Pluto.FileEditEvent)
        try
            response = HTTP.get(_export_url(e.notebook, _format_map[format]))
            save_export(format, export_path, e.notebook, response.body)
        catch e
            @warn "Failed to fetch notebook '$(format)' export"
            showerror(stderr, e)
        end
    end
    # waiting on https://github.com/fonsp/Pluto.jl/pull/1882
    # function on_pluto_event(e::Pluto.ServerStartEvent)

    # end
    on_pluto_event(e::Pluto.PlutoEvent) = nothing

    return (e::Pluto.PlutoEvent) -> on_pluto_event(e) # todo: make this async
end

function live_export(formats::Vector{String}; kwargs...)
    for format ∈ formats
        live_export(format; kwargs...)
    end
end

end # module
