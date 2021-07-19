
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sanitizer

Sanitize HTML in R. Here’s an example of a markdown strings that
includes a potentially malicious script tag. It also has a `target`
attribute in the `<a>` tag which we don’t allow by default. You can see
that we render the markdown to HTML and then sanitize the resultant HTML
to only allow the approved tags and attributes.

``` r
html <- paste0('<div><a href="https://github.com" target="_blank">',
  'Link here</a><script>something bad</script></div>')
sanitize_markdown(paste0('**hi** there ', html))
#> [1] "<p><strong>hi</strong> there <div><a href=\"https://github.com\">Link here</a></div></p>\n"
```

``` r
sanitize_html(html)
#> [1] "<div><a href=\"https://github.com\">Link here</a></div>\n"
```

``` r
node <- xml2::read_xml(html)
san <- sanitize_node(node)
as.character(san, options=c("no_declaration"))
#> [1] "<div><a href=\"https://github.com\">Link here</a></div>\n"
```
