# DocPad Configuration File
# http://docpad.org/docs/config

moment = require('moment')

# Define the DocPad Configuration

docpadConfig = {
    templateData:
        # SETTINGS
        site:
            title: "CSS PREprocessors"

            description: "CSS Preprocessors - preprocessor comparisons and reference guide, play around with all code snippets, explore tools for conversion from/to CSS"

            keywords: "css, preprocessors, preprocessor, less, sass, scss, stylus"

            url: "http://csspre.com"

        # FUNCTIONS
        getPreparedTitle: -> if @document.title then "#{@document.title} ◩ #{@site.title}" else @site.title

        getPreparedDescription:->
            # if document description exists use it, otherwise use the site's description
            if @document.description then "#{@document.description}" else @site.description

        getPreparedKeywords: ->
            # merge the document keywords with the site keywords
            @site.keywords.concat(@document.keywords or []).join(', ')

        # Post meta
        postDatetime: (date, format="YYYY-MM-DD") -> return moment(date).format(format)
        postDate: (date, format="MMMM DD, YYYY") -> return moment(date).format(format)

        code: (name, lang="css", cols="12") ->
            prt = if lang == "stylus" then @partial("#{name}.styl") else @partial("#{name}.#{lang}")
            lng = if lang != "css" then "data-csspre='#{lang}'" else ""
            id  = name + "-" + lang
            '<div class=\'col-' + cols + '\'>' +
                '<pre data-type="css" ' + lng + ' id=\'' + id + '\'><code>' + prt + '</code></pre>' +
            '</div>'

    collections:
        pages: (database) ->
            database.findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])

        posts: (database) ->
            database.findAllLive({layout:'post'}, [date:-1])

    plugins:
        rss:
            collection: "posts"
        stylus:
            stylusLibraries:
                nib: false
            stylusOptions:
                compress: true
                'include css': true
        feedr:
            feeds:
                githubRepo:
                    url: "https://api.github.com/repos/futekov/csspre"
                githubContributors:
                    url: "https://api.github.com/repos/futekov/csspre/contributors"
}

# Export the DocPad Configuration
module.exports = docpadConfig
