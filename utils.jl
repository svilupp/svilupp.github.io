function hfun_bar(vname)
    val = Meta.parse(vname[1])
    return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
    var = vname[1]
    return pagevar("index", var)
end

function lx_baz(com, _)
    # keep this first line
    brace_content = Franklin.content(com.braces[1]) # input string
    # do whatever you want here
    return uppercase(brace_content)
end

"""
    {{blogposts}}

Plug in the list of blog posts contained in the `/scratchpad/` folder.
Source: https://github.com/abhishalya/abhishalya.github.io
"""
@delay function hfun_blogposts()
    today = Dates.today()
    curyear = year(today)
    curmonth = month(today)
    curday = day(today)

    list = readdir("jan/scratchpad")
    filter!(f -> endswith(f, ".md"), list)
    sorter(p) = begin
        ps = splitext(p)[1]
        url = "/jan/scratchpad/$ps/"
        surl = strip(url, '/')
        pubdate = pagevar(surl, :published)
        if isnothing(pubdate)
            return Date(Dates.unix2datetime(stat("jan/scratchpad/$p").ctime))
        end
        return Date(pubdate, dateformat"d U Y")
    end
    sort!(list, by=sorter, rev=true)

    io = IOBuffer()
    for (i, post) in enumerate(list)
        if post == "index.md"
            continue
        end
        ps = splitext(post)[1]
        url = "/jan/scratchpad/$ps/"
        surl = strip(url, '/')
        title = pagevar(surl, :title)
        pubdate = pagevar(surl, :published)
        if isnothing(pubdate)
            date = "$curyear-$curmonth-$curday"
        else
            date = Date(pubdate, dateformat"d U Y")
        end
        write(
            io,
            """
      <div class="col">
          <a href="$url" class="text-decoration-none card-link">
              <div class="card h-100 shadow-sm">
                  <div class="card-body d-flex flex-column">
                      <div class="d-flex align-items-center justify-content-center bg-light rounded-circle mb-3 mx-auto" style="width: 48px; height: 48px;">
                          <i class="bi bi-file-text"></i>
                      </div>
                      <h5 class="card-title text-center mb-2 text-dark">$(isnothing(title) ? ps : title)</h5>
                      <p class="card-subtitle mb-3 text-muted text-center small">$date</p>
                  </div>
              </div>
          </a>
      </div>
  """
        )
    end
    return String(take!(io))
end

"""
    {{recentposts}}

Plug in the list of recent blog posts, limited to 6 most recent.
"""
@delay function hfun_recentposts()
    today = Dates.today()
    curyear = year(today)
    curmonth = month(today)
    curday = day(today)

    list = readdir("jan/scratchpad")
    filter!(f -> endswith(f, ".md"), list)
    sorter(p) = begin
        ps = splitext(p)[1]
        url = "/jan/scratchpad/$ps/"
        surl = strip(url, '/')
        pubdate = pagevar(surl, :published)
        if isnothing(pubdate)
            return Date(Dates.unix2datetime(stat("jan/scratchpad/$p").ctime))
        end
        return Date(pubdate, dateformat"d U Y")
    end
    sort!(list, by=sorter, rev=true)

    io = IOBuffer()
    # Limit to 6 most recent posts
    list = list[1:min(6, length(list))]
    for (i, post) in enumerate(list)
        if post == "index.md"
            continue
        end
        ps = splitext(post)[1]
        url = "/jan/scratchpad/$ps/"
        surl = strip(url, '/')
        title = pagevar(surl, :title)
        pubdate = pagevar(surl, :published)
        if isnothing(pubdate)
            date = "$curyear-$curmonth-$curday"
        else
            date = Date(pubdate, dateformat"d U Y")
        end
        write(
            io,
            """
      <div class="col">
          <a href="$url" class="text-decoration-none card-link">
              <div class="card h-100 shadow-sm">
                  <div class="card-body d-flex flex-column">
                      <div class="d-flex align-items-center justify-content-center bg-light rounded-circle mb-3 mx-auto" style="width: 48px; height: 48px;">
                          <i class="bi bi-file-text"></i>
                      </div>
                      <h5 class="card-title text-center mb-2 text-dark">$(isnothing(title) ? ps : title)</h5>
                      <p class="card-subtitle mb-3 text-muted text-center small">$date</p>
                  </div>
              </div>
          </a>
      </div>
  """
        )
    end
    return String(take!(io))
end

"""
    {{wipposts}}

Plug in the list of blog posts contained in the `/jan/wip/` folder.
Source: https://github.com/abhishalya/abhishalya.github.io
"""
@delay function hfun_wipposts()
    today = Dates.today()
    curyear = year(today)
    curmonth = month(today)
    curday = day(today)

    list = readdir("jan/wip")
    filter!(f -> endswith(f, ".md"), list)
    sorter(p) = begin
        ps = splitext(p)[1]
        url = "/jan/wip/$ps/"
        surl = strip(url, '/')
        pubdate = pagevar(surl, :drafted)
        if isnothing(pubdate)
            return Date(Dates.unix2datetime(stat("jan/wip/$p").ctime))
        end
        return Date(pubdate, dateformat"d U Y")
    end
    sort!(list, by=sorter, rev=true)

    io = IOBuffer()
    for (i, post) in enumerate(list)
        if post == "index.md"
            continue
        end
        ps = splitext(post)[1]
        url = "/jan/wip/$ps/"
        surl = strip(url, '/')
        title = pagevar(surl, :title)
        pubdate = pagevar(surl, :drafted)
        if isnothing(pubdate)
            date = "$curyear-$curmonth-$curday"
        else
            date = Date(pubdate, dateformat"d U Y")
        end
        write(
            io,
            """
      <div class="col">
          <a href="$url" class="text-decoration-none card-link">
              <div class="card h-100 shadow-sm">
                  <div class="card-body d-flex flex-column">
                      <div class="d-flex align-items-center justify-content-center bg-light rounded-circle mb-3 mx-auto" style="width: 48px; height: 48px;">
                          <i class="bi bi-file-text"></i>
                      </div>
                      <h5 class="card-title text-center mb-2 text-dark">$(isnothing(title) ? ps : title)</h5>
                      <p class="card-subtitle mb-3 text-muted text-center small">$date</p>
                  </div>
              </div>
          </a>
      </div>
  """
        )
    end
    return String(take!(io))
end

"""
    {{recentwipposts}}

Plug in the list of recent WIP posts, limited to 6 most recent.
"""
@delay function hfun_recentwipposts()
    today = Dates.today()
    curyear = year(today)
    curmonth = month(today)
    curday = day(today)

    list = readdir("jan/wip")
    filter!(f -> endswith(f, ".md"), list)
    sorter(p) = begin
        ps = splitext(p)[1]
        url = "/jan/wip/$ps/"
        surl = strip(url, '/')
        pubdate = pagevar(surl, :drafted)
        if isnothing(pubdate)
            return Date(Dates.unix2datetime(stat("jan/wip/$p").ctime))
        end
        return Date(pubdate, dateformat"d U Y")
    end
    sort!(list, by=sorter, rev=true)

    io = IOBuffer()
    # Limit to 6 most recent posts
    list = list[1:min(6, length(list))]
    for (i, post) in enumerate(list)
        if post == "index.md"
            continue
        end
        ps = splitext(post)[1]
        url = "/jan/wip/$ps/"
        surl = strip(url, '/')
        title = pagevar(surl, :title)
        pubdate = pagevar(surl, :drafted)
        if isnothing(pubdate)
            date = "$curyear-$curmonth-$curday"
        else
            date = Date(pubdate, dateformat"d U Y")
        end
        write(
            io,
            """
      <div class="col">
          <a href="$url" class="text-decoration-none card-link">
              <div class="card h-100 shadow-sm">
                  <div class="card-body d-flex flex-column">
                      <div class="d-flex align-items-center justify-content-center bg-light rounded-circle mb-3 mx-auto" style="width: 48px; height: 48px;">
                          <i class="bi bi-file-text"></i>
                      </div>
                      <h5 class="card-title text-center mb-2 text-dark">$(isnothing(title) ? ps : title)</h5>
                      <p class="card-subtitle mb-3 text-muted text-center small">$date</p>
                  </div>
              </div>
          </a>
      </div>
  """
        )
    end
    return String(take!(io))
end

"""
    {{custom_taglist}}

Plug in the list of blog posts with the given tag
"""
function hfun_custom_taglist()::String
    tag = locvar(:fd_tag)
    rpaths = globvar("fd_tag_pages")[tag]
    sorter(p) = begin
        pubdate = pagevar(p, :published)
        if isnothing(pubdate)
            return Date(Dates.unix2datetime(stat(p * ".md").ctime))
        end
        return Date(pubdate, dateformat"d U Y")
    end
    sort!(rpaths, by=sorter, rev=true)

    io = IOBuffer()
    write(io, """<ul class="blog-posts">""")
    # go over all paths
    for rpath in rpaths
        write(io, "<li><span><i>")
        url = get_url(rpath)
        title = pagevar(rpath, :title)
        pubdate = pagevar(rpath, :published)
        if isnothing(pubdate)
            date = "$curyear-$curmonth-$curday"
        else
            date = Date(pubdate, dateformat"d U Y")
        end
        # write some appropriate HTML
        write(io, """$date   </i></span><a href="$url">$title</a>""")
    end
    write(io, "</ul>")
    return String(take!(io))
end
