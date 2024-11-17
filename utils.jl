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
        ps  = splitext(p)[1]
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
    write(io, "<div class=\"row g-4\">")
    for (i, post) in enumerate(list)
        if i > 5  # Only show 5 most recent posts
            break
        end
        if post == "index.md"
            continue
        end
        ps  = splitext(post)[1]
        url = "/jan/scratchpad/$ps/"
        surl = strip(url, '/')
        title = pagevar(surl, :title)
        pubdate = pagevar(surl, :published)
        if isnothing(pubdate)
            date = "$curyear-$curmonth-$curday"
        else
            date = Date(pubdate, dateformat"d U Y")
        end
        write(io, "<div class=\"col-md-6\"><div class=\"card h-100 shadow-sm\"><div class=\"card-body\">")
        write(io, "<h5 class=\"card-title\">$(isnothing(title) ? ps : title)</h5>")
        write(io, "<h6 class=\"card-subtitle mb-2 text-muted\">$date</h6>")
        write(io, "<a href=\"$url\" class=\"btn btn-primary mt-2\">Read More</a>")
        write(io, "</div></div></div>")
    end
    write(io, "</div>")
    write(io, "<div class=\"text-center mt-4\"><p class=\"text-muted\">View all posts in the <a href=\"/jan/scratchpad/\">Posts</a> section</p></div>")
    return String(take!(io))
end

"""
    {{wipposts}}

Plug in the list of blog posts contained in the `/wip/` folder.
Source: https://github.com/abhishalya/abhishalya.github.io
"""
@delay function hfun_wipposts()
    today = Dates.today()
    curyear = year(today)
    curmonth = month(today)
    curday = day(today)

    list = readdir("wip")
    filter!(f -> endswith(f, ".md"), list)
    sorter(p) = begin
        ps  = splitext(p)[1]
        url = "/wip/$ps/"
        surl = strip(url, '/')
        pubdate = pagevar(surl, :published)
        if isnothing(pubdate)
            return Date(Dates.unix2datetime(stat(surl * ".md").ctime))
        end
        return Date(pubdate, dateformat"d U Y")
    end
    sort!(list, by=sorter, rev=true)

    io = IOBuffer()
    write(io, "<div class=\"card shadow-sm mt-4\"><div class=\"card-body\">")
    write(io, "<h5 class=\"card-title mb-4\">Work in Progress</h5>")
    write(io, "<div class=\"list-group list-group-flush\">")
    for (i, post) in enumerate(list)
        if i > 5  # Only show 5 most recent WIP posts
            break
        end
        if post == "index.md"
            continue
        end
        ps  = splitext(post)[1]
        url = "/wip/$ps/"
        surl = strip(url, '/')
        title = pagevar(surl, :title)
        pubdate = pagevar(surl, :published)
        if isnothing(pubdate)
            date    = "$curyear-$curmonth-$curday"
        else
            date    = Date(pubdate, dateformat"d U Y")
        end
        write(io, """<a href="$url" class="list-group-item list-group-item-action">
                     <div class="d-flex w-100 justify-content-between">
                       <h6 class="mb-1">$title</h6>
                       <small class="text-muted">$date</small>
                     </div>
                   </a>""")
    end
    write(io, "</div></div></div>")
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
            date    = "$curyear-$curmonth-$curday"
        else
            date    = Date(pubdate, dateformat"d U Y")
        end
        # write some appropriate HTML
        write(io, """$date   </i></span><a href="$url">$title</a>""")
    end
    write(io, "</ul>")
    return String(take!(io))
end
