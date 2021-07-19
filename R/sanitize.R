#' Sanitize an xml2 node
#' @param node An xml2 node
#' @param safe_tags the list of tags which are to be permitted during sanitization.
#' @importFrom xml2 xml_children
#' @importFrom xml2 xml_name
#' @importFrom xml2 xml_attrs
#' @importFrom xml2 xml_set_attrs
#' @importFrom xml2 xml_remove
#' @export
sanitize_node <- function(node, safe_tags = default_tags){
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
#' @param html An HTML string to be sanitized
#' @param safe_tags the list of tags which are to be permitted during sanitization.
#' @export
sanitize_html <- function(html, safe_tags = default_tags) {
  node <- xml2::read_xml(html)
  san <- sanitize_node(node, safe_tags)
  as.character(san, options=c("no_declaration"))
}

#' Sanitize a markdown string
#'
#' Which can also contain HTML inside of it.
#'
#' @param md Markdown to be parsed and sanitized.
#' @param safe_tags the list of tags which are to be permitted during sanitization.
#' @export
sanitize_markdown <- function(md, safe_tags = default_tags) {
  if (!requireNamespace("commonmark", quietly = TRUE)) {
    stop("commonmark required for sanitize_markdown")
  }
  html <- commonmark::markdown_html(text=md)
  san <- sanitize_html(html, safe_tags)
  as.character(san, options=c("no_declaration"))
}
