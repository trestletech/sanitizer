test_that("sanitize_node works", {
  san <- sanitize_node(xml2::read_xml('<div><span class="what">stuff here</span><iframe src=""></iframe><hr /></div>'),
                  safe_tags)
  # Scrub the iframe tag, scrub the class attribute
  expect_equal(as.character(san, options=c("no_declaration")), "<div><span>stuff here</span><hr/></div>\n")

  # Permitted attributes make it through
  san <- sanitize_node(xml2::read_xml('<a href="whatever">hi</a>'), safe_tags)
  expect_equal(as.character(san, options=c("no_declaration")), '<a href="whatever">hi</a>\n')

  # Top level is invalid
  san <- sanitize_node(xml2::read_xml('<iframe src="" />'), safe_tags)
  expect_null(san)
})

test_that("sanitize_html works", {
  html <- '<p><a href="https://yahoo.com" target="_blank">link</a><hr /><script>what</script></p>'
  san <- sanitize_html(html, safe_tags)
  expect_equal(as.character(san, options=c("no_declaration")), "<p><a href=\"https://yahoo.com\">link</a><hr/></p>\n")
})


test_that("sanitize_markdown works", {
  md <- '**hi**<a href="https://yahoo.com" target="_blank">link</a><hr /><script>what</script> there'
  san <- sanitize_markdown(md, safe_tags)
  expect_equal(
    as.character(san, options=c("format","no_declaration")),
    "<p><strong>hi</strong><a href=\"https://yahoo.com\">link</a><hr/> there</p>\n"
  )
})
