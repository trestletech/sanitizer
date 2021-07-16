#' Sanitize an xml2 node
#' @importFrom xml2 xml_children
#' @importFrom xml2 xml_name
#' @importFrom xml2 xml_attrs
#' @importFrom xml2 xml_set_attrs
#' @importFrom xml2 xml_remove
#' @export
sanitize_node <- function(node, safe_tags = safe_tags){
  # lookup rules for this node
  nm <- xml_name(node)
  safe <- safe_tags[[nm]]
  if (is.null(safe)) {
    xml_remove(node)
    return()
  }

  # scrub the attributes
  attrs <- xml_attrs(node)
  if (length(attrs) > 0){
    xml_set_attrs(node, attrs[names(attrs) %in% safe])
  }

  children <- xml_children(node)
  if (length(children) > 0) {
    sapply(children, sanitize_node, safe_tags = safe_tags)
  }
  node
}

#' Sanitize an HTML string
#' @export
sanitize_html <- function(html, safe_tags = safe_tags) {
  node <- xml2::read_xml(html)
  sanitize_node(node, safe_tags)
}

#' Sanitize a markdown string
#'
#' Which can also contain HTML inside of it.
#' @export
sanitize_markdown <- function(md, safe_tags = safe_tags) {
  html <- markdown::markdownToHTML(text=md, fragment.only = TRUE)
  sanitize_html(html, safe_tags)
}
